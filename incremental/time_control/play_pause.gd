extends TextureButton

func _ready() -> void:
	print("signal: %s (%s)" % [name,connect("toggled", self, "_on_toggle")])


func _on_toggle(state:bool):
	GameTimer._on_change_time_speed(state)
