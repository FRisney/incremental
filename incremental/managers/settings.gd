extends Node

export(Array,NodePath) var res_refs
export(Array,NodePath) var tech_refs
var save: int = 1

var data_buffer: Dictionary = { }


func _init():
	if !data_buffer.has("unlocked_techs"):
		data_buffer.unlocked_techs = Array()


func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("endofyear", self, "save_routine")])


func enlist(type:String, path:NodePath):
	get("%s_refs"%type).push_back(path)
	# print("%s_refs - %s"%[type,path])


func set_persistent_data() -> void:
	var save_path:String = "user://save-%s.save" % Settings.save
	var file: File = File.new()
	if !file.file_exists(save_path):
		var dir: Directory = Directory.new()
		dir.open("res://content")
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		while file_name != "":
			var res: Resource = load("res://content/"+file_name)
			var res_type:String = file_name.get_basename()
			data_buffer[res_type] = {
				"name": res.get("resource_name"),
				"current": res.get("current"),
				"capacity": res.get("capacity"),
				"manual_extract": res.get("manual_extract"),
				"extractors": res.get("extractors"),
				"storages": res.get("storages"),
			}
			file_name = dir.get_next()
		dir.list_dir_end()
	if !OS.is_debug_build():
		file.open_compressed(save_path,File.WRITE, File.COMPRESSION_ZSTD)
	else:
		file.open(save_path,File.WRITE)
	file.store_string(to_json(data_buffer))
	file.close()


func set_persistent_resource_data(res_type:String, data:Dictionary) -> void:
	var path:String = ""
	path = ("user://save-%s.save" % Settings.save)
	var file: File = File.new()
	if !file.file_exists(path):
		set_persistent_data()

	if !OS.is_debug_build():
		file.open_compressed(path,File.READ_WRITE, File.COMPRESSION_ZSTD)
	else:
		file.open(path,File.READ_WRITE)
	var dict:Dictionary = parse_json(file.get_as_text())
	dict[res_type] = data
	file.store_string(to_json(dict))
	file.close()


func get_persistent_resource_data(res_type:String) -> Dictionary:
	var path:String = ""
	path = ("user://save-%s.save" % Settings.save)
	var file: File = File.new()
	if !file.file_exists(path):
		set_persistent_data()

	if !OS.is_debug_build():
		file.open_compressed(path,File.READ, File.COMPRESSION_ZSTD)
	else:
		file.open(path,File.READ)
	var dict:Dictionary = parse_json(file.get_as_text())
	file.close()
	return dict[res_type]


func save_routine():
	for node_path in res_refs:
		var node = get_node(node_path)
		var data:Dictionary = node.get("data")
		for key in data:
			data_buffer[node.res_type] = data
	for node_path in tech_refs:
		var node = get_node(node_path)
		if !data_buffer.unlocked_techs.has(node.get("tech_id")) and node.get("done"):
			data_buffer.unlocked_techs.append(node.get("tech_id"))
	set_persistent_data()
