extends PanelContainer

export(Array, String) var items

func _ready() -> void:
	for item in items:
		var res_ext = (load("res://components/info/resource_construct.tscn")as PackedScene).instance() as Label
		($M/S/V as VBoxContainer).add_child(res_ext)
		res_ext.text = "%s: " % item


# func display_content(data):


