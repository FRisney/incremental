extends "res://logic/resource.gd"

onready var lbl_current: Label = get_node("Scroll/Stack/QC/MC/Quantity/Current")
onready var lbl_capacity: Label = get_node("Scroll/Stack/QC/MC/Quantity/Capacity")
onready var prog_bar: ProgressBar = get_node("Scroll/Stack/QC/ProgBar")

func _ready() -> void:
	._ready()

	(get_node("Scroll/Stack/Title") as Label).text = res_name
	lbl_capacity.text = "%s" % capacity
	prog_bar.max_value = capacity

	if manual_extract > 0:
		var btn:Button = Button.new()
		btn.connect("pressed",self,"extract")
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


func _on_build_extractor(extractor:int,btn:Button):
	build_extractor(extractor)
	btn.text = "Extractor %s [%s]" % [ extractors[extractor].id, extractors[extractor].builded ]


func _on_build_storage(storage:int,btn:Button):
	build_storage(storage)
	btn.text = "Storage %s [%s]" % [ storages[storage].id, storages[storage].builded ]
	lbl_capacity.text = "%s" % capacity
	prog_bar.max_value = capacity
