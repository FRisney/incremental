extends Control

export var res_type: String

onready var lbl_current: Label = get_node("Scroll/Stack/QC/MC/Quantity/Current")
onready var lbl_capacity: Label = get_node("Scroll/Stack/QC/MC/Quantity/Capacity")
onready var prog_bar: ProgressBar = get_node("Scroll/Stack/QC/ProgBar")

var data:Dictionary = { }

func _enter_tree() -> void:
	data = Settings.call("get_persistent_resource_data", res_type)

func _ready() -> void:
	Settings.call("enlist",self.get_path())
	# print("signal: %s (%s)" % [name,GameTimer.connect("endofyear", self, "save_state")])
	(get_node("Scroll/Stack/Title") as Label).text = data.name
	data.capacity = calc_capacity()
	lbl_capacity.text = "%s" % data.capacity
	prog_bar.max_value = data.capacity

	if data.manual_extract > 0:
		var btn:Button = Button.new()
		btn.connect("pressed",self,"_on_extract")
		btn.name = "Extract"
		btn.text = "Extract"
		find_node("Stack").add_child_below_node(get_node("Scroll/Stack/QC"),btn)


func _process(_delta: float) -> void:
	prog_bar.value = data.current
	lbl_current.text = "%s" % data.current


func _on_extract():
	if !GameTimer.is_stopped():
		var _e: int = data.current + data.manual_extract
		data.current = _e if _e < data.capacity else data.capacity


# func _on_build_extractor():
# 	data


func _on_build_storage():
	lbl_capacity.text = "%s" % data.capacity


func calc_capacity() -> int:
	var cap:int = 0
	for storage in data.storages:
		var exp_cap = Expression.new()
		exp_cap.parse(storage.stores, ["x"])
		cap += exp_cap.execute([storage.builded])
	cap = cap if cap > data.capacity else data.capacity
	return cap


# func save_state() ->void:
# 	if !Settings.get("data_buffer").has(res_type):
# 		Settings.call("set_persistent_resource_data", res_type, data)
# 	else:
# 		Settings.get("data_buffer")[res_type] = data
