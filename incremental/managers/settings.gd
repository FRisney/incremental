extends Node

# Base registry of various aspects of the game

enum ResTypes { RES_A, RES_B, RES_C, RES_D, RES_E }

var res_refs: PoolStringArray
var save: int = 1


func enlist(path:NodePath):
	res_refs.append(path)
	print(path)


func get_persistent_data(res_type:int) -> Dictionary:
	var path:String = ""
	match (res_type):
		Settings.ResTypes.RES_A:
			path = "res_a"
	path = ("user://%s/%s.sav" % [ Settings.save, path ])
	var file: File = File.new()
	file.open(path,File.READ)
	return parse_json(file.get_as_text())
