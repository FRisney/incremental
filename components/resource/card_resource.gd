extends PanelContainer

export(Array, String) var items

func _ready() -> void:
	($M/S/V/T as Label).text = name

	for item in items:
		var new_label = (load("res://components/info/resource_construct.tscn")as PackedScene).instance() as Label
		($M/S/V as VBoxContainer).add_child(new_label)
		new_label.text = "%s: " % item


# func display_content(data):


