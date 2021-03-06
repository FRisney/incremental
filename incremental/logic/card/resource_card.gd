extends Control

export(Settings.ResTypes) var res_type

onready var lbl_current: Label = get_node("Scroll/Stack/QC/MC/Quantity/Current")
onready var lbl_capacity: Label = get_node("Scroll/Stack/QC/MC/Quantity/Capacity")
onready var prog_bar: ProgressBar = get_node("Scroll/Stack/QC/ProgBar")

var data:Dictionary = {
	"capacity": 15,
	"current": 0,
	"extractors_builded": { },
	"storages_builded": { },
}

func _enter_tree() -> void:
	data = Settings.call("get_persistent_data", res_type)

func _ready() -> void:
	# load_data()
	Settings.call("enlist",self.get_path())
	(get_node("Scroll/Stack/Title") as Label).text = data.get("resource_name")
	lbl_capacity.text = "%s" % data.get("capacity")
	prog_bar.max_value = data.get("capacity")

	

	if data.get("manual_extract") > 0:
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
		var _e: int = data.current + data.get("manual_extract")
		data.current = _e if _e < data.capacity else data.capacity


# func _on_build_extractor():
# 	data


func _on_build_storage():
	lbl_capacity.text = "%s" % data.capacity


# func _on_save() -> void:
# 	persistent_data.set("current", data.current)
# 	persistent_data.set("capacity", data.capacity)
# 	for extractor in data.extractors:
# 		persistent_data.get("extractors")[extractor].set("builded", data[extractor].builded)
# 	for storage in data.storages:
# 		persistent_data.get("storages")[storage].set("builded", data[storage].builded)

# func load_data():
# 	data.capacity = persistent_data.get("capacity")
# 	data.current = persistent_data.get("current")

# 	var i:int=0
# 	for extractor in persistent_data.get("extractors"):
# 		# print(extractor)
# 		# if !data.extractors_builded.has(i):
# 		# 	data.extractors_builded[i] = 0;
# 		data.extractors_builded[i] = persistent_data.get("extractors")[i].builded
# 		i += 1

# 	i = 0
# 	for storage in persistent_data.get("storages"):
# 		# if !data.storages_builded.has(i):
# 		# 	data.storages_builded.append(i)
# 		data.storages_builded[i] = persistent_data.get("storages")[i].builded
# 		i += 1
