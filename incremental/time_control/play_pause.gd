extends TextureButton

func _ready() -> void:
	connect("toggled", self, "_on_toggle")


func _on_toggle(state:bool):
	if GameTimer.is_stopped():
		GameTimer.start()
	elif state:
		GameTimer.set_paused(true)
	else:
		GameTimer.set_paused(false)

