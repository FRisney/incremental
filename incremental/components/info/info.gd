extends Node

export(Dictionary) var items

func _ready() -> void:
	for item in items:
		var new_label = (load("res://components/info/display.tscn")as PackedScene).instance()
		($M/S/V as VBoxContainer).add_child(new_label)
		print("signal: %s (%s)" % [name,GameTimer.connect("ticked", new_label, "display_values")])
		new_label.desc = item
		new_label.val = "%s" % items[item]
		new_label.display_values()

