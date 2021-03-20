extends Control

export var res_type: String

onready var lbl_current: Label = get_node("Scroll/Stack/QC/MC/Quantity/Current")
onready var lbl_capacity: Label = get_node("Scroll/Stack/QC/MC/Quantity/Capacity")
onready var prog_bar: ProgressBar = get_node("Scroll/Stack/QC/ProgBar")

var data:Dictionary = { }

func _enter_tree() -> void:
	data = Settings.call("get_persistent_resource_data", res_type)

func _ready() -> void:
	Settings.call("enlist","res", res_type, self.get_path())
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

	for extractor in data.extractors:
		var btn: Button = Button.new()
		btn.name = "%s" % extractor.id
		btn.text = "Extractor %s [%s]" % [ extractor.id, extractor.builded ]
		print("signal: %s (%s)" % [name,btn.connect("pressed", self, "_on_build_extractor", [extractor.id,btn])])
		get_node("Scroll/Stack/Extractors").add_child(btn)

	for storage in data.storages:
		var btn: Button = Button.new()
		btn.name = "%s" % storage.id
		btn.text = "Storage %s [%s]" % [ storage.id, storage.builded ]
		print("signal: %s (%s)" % [name,btn.connect("pressed", self, "_on_build_storage", [storage.id,btn])])
		get_node("Scroll/Stack/Storages").add_child(btn)


func _process(_delta: float) -> void:
	prog_bar.value = data.current
	lbl_current.text = "%s" % data.current


func _on_extract():
	if !GameTimer.is_stopped():
		var _e: int = data.current + data.manual_extract
		data.current = _e if _e < data.capacity else data.capacity


func _on_build_extractor(extractor:int,btn:Button):
	data.extractors[extractor].builded += 1;
	btn.text = "Extractor %s [%s]" % [ data.extractors[extractor].id, data.extractors[extractor].builded ]


func _on_build_storage(storage:int,btn:Button):
	data.storages[storage].builded += 1;
	data.capacity = calc_capacity()
	btn.text = "Storage %s [%s]" % [ data.storages[storage].id, data.storages[storage].builded ]
	lbl_capacity.text = "%s" % data.capacity
	prog_bar.max_value = data.capacity


func calc_capacity() -> int:
	var cap:int = data.capacity
	for storage in data.storages:
		var exp_cap = Expression.new()
		exp_cap.parse(storage.stores, ["x"])
		cap += exp_cap.execute([storage.builded])
	cap = cap if cap > data.capacity else data.capacity
	return cap
