extends Node

export(Dictionary) var items

func _ready() -> void:
	for item in items:
		print(item)
		var new_label = (load("res://components/info/display.tscn")as PackedScene).instance()
		($M/S/V as VBoxContainer).add_child(new_label)
		new_label.connect("ticked", new_label, "displayValues")
		new_label.desc = item
		new_label.val = "%s" % items[item]
		new_label.displayValues()

