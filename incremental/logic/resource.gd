extends Node

export var res_type: String

# var data:Dictionary = { }
var res_name:String = ""
var capacity:int = 0
var current:int = 0
var manual_extract:int = 0
var storages:Array = []
var extractors:Array = []


func get_data() -> Dictionary:
	var data: Dictionary = {
		"name": name,
		"capacity": capacity,
		"current": current,
		"manual_extract": manual_extract,
		"storages": storages,
		"extractors": extractors,
	}
	return data


func _enter_tree() -> void:
	var data:Dictionary = Settings.call("get_persistent_resource_data", res_type)
	res_name       = data.get('name')
	capacity       = data.get('capacity')
	current        = data.get('current')
	manual_extract = data.get('manual_extract')
	storages       = data.get('storages')
	extractors     = data.get('extractors')

func _ready() -> void:
	Settings.call("enlist","res", res_type, self.get_path())
	if capacity == 0:
		capacity = calc_capacity()


func extract():
	if !GameTimer.is_stopped():
		var _e: int = current + manual_extract
		current = _e if _e < capacity else capacity


func build_extractor(extractor:int):
	extractors[extractor].builded += 1;


func build_storage(storage:int):
	storages[storage].builded += 1;
	capacity = calc_capacity()


func calc_capacity() -> int:
	var new_cap:int = capacity
	for storage in storages:
		var exp_cap = Expression.new()
		exp_cap.parse(storage.stores, ["x"])
		new_cap += exp_cap.execute([storage.builded])
	return new_cap


func increase_resource(quantity:int) -> void:
	current += quantity if current + quantity >= capacity else 0


func decrease_resource(quantity:int) -> void:
	current -= quantity if current - quantity >= 0 else 0

