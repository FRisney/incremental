extends Label


export(String) var res_type


func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "update_text")])


func update_text():
	text = "%s" % Storage.get(res_type)

