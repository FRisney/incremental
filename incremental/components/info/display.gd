extends Label

enum DisplayType {
	NAME,
	QUANTITY,
}

export(DisplayType) var display_type
export(Settings.Resources) var res_type


func _ready() -> void:
	if display_type == DisplayType.NAME:
		text = Storage.get_res_name(res_type)
		return
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "update_text")])


func update_text():
	text = "%s" % Storage.get_current(res_type)

