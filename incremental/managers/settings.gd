extends Node

export(Dictionary) var res_refs
export(Dictionary) var tech_refs
var save: int = 1

var data_buffer: Dictionary = { }


func _init():
	load_data()


func _ready() -> void:
	GameTimer.connect("endofyear", self, "save_routine")


func enlist(type:String, id:String, path:NodePath):
	get("%s_refs"%type)[id] = path


func get_node_by_ref(type:String, id:String) -> Node:
	return get_node(get("%s_refs"%type)[id])


func get_res_current(type:String) -> Node:
	return get_node_by_ref('res', type).call("get_data").get("current")


func unlock_tech(id:String) -> void:
	data_buffer.get("unlocked_techs").append(id)


func decrease_resource(res:String, quantity:int) -> void:
	get_node_by_ref('res', res).call('decrease_resource',quantity)


func set_persistent_data() -> void:
	var save_path:String = "user://save-%s.save" % save
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
				"current": int(res.get("current")),
				"capacity": int(res.get("capacity")),
				"manual_extract": res.get("manual_extract"),
				"extractors": res.get("extractors"),
				"storages": res.get("storages"),
			}
			file_name = dir.get_next()
		dir.list_dir_end()
		data_buffer.tick = 0
		data_buffer.unlocked_techs = []
	if !OS.is_debug_build():
		file.open_compressed(save_path,File.WRITE, File.COMPRESSION_ZSTD)
	else:
		file.open(save_path,File.WRITE)
	file.store_string(to_json(data_buffer))
	file.close()


func set_persistent_resource_data(res_type:String, data:Dictionary) -> void:
	var path:String = ""
	path = ("user://save-%s.save" % save)
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
	# var dict:Dictionary = parse_json(file.get_as_text())
	return data_buffer[res_type]


func load_data() -> void:
	var path:String = ""
	path = ("user://save-%s.save" % save)
	var file: File = File.new()
	if !file.file_exists(path):
		set_persistent_data()

	if !OS.is_debug_build():
		file.open_compressed(path,File.READ, File.COMPRESSION_ZSTD)
	else:
		file.open(path,File.READ)
	var result = JSON.parse(file.get_as_text())
	if result.error == ERR_PARSE_ERROR:
		var file_path = file.get_path_absolute()
		file.close()
		var dir = Directory.new()
		dir.open(file_path.get_base_dir())
		dir.remove(file_path)
		dir.close()
		load_data()
	else:
		data_buffer = result.result
		file.close()


func save_routine():
	data_buffer.tick = GameTimer.get("tick")
	for res_type in res_refs:
		var data:Dictionary = get_node(res_refs[res_type]).call("get_data")
		for key in data:
			data_buffer[res_type] = data
	for tech_id in tech_refs:
		if !data_buffer.unlocked_techs.has(tech_id) and get_node(tech_refs[tech_id]).get("done"):
			data_buffer.unlocked_techs.append(tech_id)
	set_persistent_data()
