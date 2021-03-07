extends Node

# Base registry of various aspects of the game

enum ResTypes { RES_A, RES_B, RES_C, RES_D, RES_E }

var res_refs: PoolStringArray
var save: int = 1

var data_buffer: Dictionary = {
	"unlocked_techs": [
		1,2,3,4,5,6,7,8,9,10,12
	]
}

func enlist(path:NodePath):
	res_refs.append(path)
	print(path)


func set_persistent_data() -> void:
	var save_path:String = "user://save-%s.save" % Settings.save
	var file: File = File.new()
	# var dict: Dictionary = {}
	if !file.file_exists(save_path):
		var dir: Directory = Directory.new()
		dir.open("res://content")
		dir.list_dir_begin(true,true)
		var file_name = dir.get_next()
		print("Before read contents")
		while file_name != "":
			file.open("res://content/"+file_name,File.READ)
			var res: Resource = load(file.get_path())
			var res_name:String = file_name.get_basename()
			data_buffer[res_name] = {}
			data_buffer[res_name].current = res.get("current")
			data_buffer[res_name].capacity = res.get("capacity")
			data_buffer[res_name].extractors = res.get("extractors")
			data_buffer[res_name].storages = res.get("storages")
			data_buffer[res_name].manual_extract = res.get("manual_extract")
			data_buffer[res_name].type = res.get("type")
			data_buffer[res_name].name = res.get("resource_name")
			file_name = dir.get_next()
		dir.list_dir_end()
	file.open(save_path,File.WRITE)
	file.store_string(to_json(data_buffer))
	file.close()


func get_persistent_resource_data(res_type:int=-1) -> Dictionary:
	var path:String = ""
	path = ("user://save-%s.save" % Settings.save)
	var file: File = File.new()
	if !file.file_exists(path):
		set_persistent_data()

	file.open(path,File.READ)
	var dict:Dictionary = parse_json(file.get_as_text())

	match (res_type):
		ResTypes.RES_A:
			return dict["r_a"]
		_:
			return dict
