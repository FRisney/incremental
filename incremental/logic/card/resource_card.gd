extends Control

export var res_type: String

onready var lbl_current: Label = get_node("Scroll/Stack/QC/MC/Quantity/Current")
onready var lbl_capacity: Label = get_node("Scroll/Stack/QC/MC/Quantity/Capacity")
onready var prog_bar: ProgressBar = get_node("Scroll/Stack/QC/ProgBar")

# var data:Dictionary = { }
var res_name:String = ""
var capacity:int = 0
var current:int = 0
var manual_extract:int = 0
var storages:Array = []
var extractors:Array = []


func _enter_tree() -> void:
	var data:Dictionary = Settings.call("get_persistent_resource_data", res_type)
	res_name       = data.name
	capacity       = data.capacity
	current        = data.current
	manual_extract = data.manual_extract
	storages       = data.storages
	extractors     = data.extractors    

func get_data() -> Dictionary:
	var data: Dictionary = { }
	data.name = name
	data.capacity = capacity
	data.current = current
	data.manual_extract = manual_extract
	data.storages = storages
	data.extractors = extractors    
	return data


func _ready() -> void:
	Settings.call("enlist","res", res_type, self.get_path())
	(get_node("Scroll/Stack/Title") as Label).text = res_name
	if capacity == 0:
		capacity = calc_capacity()
	lbl_capacity.text = "%s" % capacity
	prog_bar.max_value = capacity

	if manual_extract > 0:
		var btn:Button = Button.new()
		btn.connect("pressed",self,"_on_extract")
		btn.name = "Extract"
		btn.text = "Extract"
		find_node("Stack").add_child_below_node(get_node("Scroll/Stack/QC"),btn)

	for extractor in extractors:
		var btn: Button = Button.new()
		btn.name = "%s" % extractor.id
		btn.text = "Extractor %s [%s]" % [ extractor.id, extractor.builded ]
		btn.connect("pressed", self, "_on_build_extractor", [extractor.id,btn])
		get_node("Scroll/Stack/Extractors").add_child(btn)

	for storage in storages:
		var btn: Button = Button.new()
		btn.name = "%s" % storage.id
		btn.text = "Storage %s [%s]" % [ storage.id, storage.builded ]
		btn.connect("pressed", self, "_on_build_storage", [storage.id,btn])
		get_node("Scroll/Stack/Storages").add_child(btn)


func _process(_delta: float) -> void:
	prog_bar.value = current
	lbl_current.text = "%s" % current


func _on_extract():
	if !GameTimer.is_stopped():
		var _e: int = current + manual_extract
		current = _e if _e < capacity else capacity


func _on_build_extractor(extractor:int,btn:Button):
	extractors[extractor].builded += 1;
	btn.text = "Extractor %s [%s]" % [ extractors[extractor].id, extractors[extractor].builded ]


func _on_build_storage(storage:int,btn:Button):
	storages[storage].builded += 1;
	capacity = calc_capacity()
	btn.text = "Storage %s [%s]" % [ storages[storage].id, storages[storage].builded ]
	lbl_capacity.text = "%s" % capacity
	prog_bar.max_value = capacity


func calc_capacity() -> int:
	var new_cap:int = capacity
	for storage in storages:
		var exp_cap = Expression.new()
		exp_cap.parse(storage.stores, ["x"])
		new_cap += exp_cap.execute([storage.builded])
	return new_cap


func consume_resource(amount:int) -> void:
	current -= amount if current - amount >= 0 else 0

