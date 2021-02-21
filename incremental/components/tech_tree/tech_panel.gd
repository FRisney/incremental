extends ViewportContainer

func _process(_delta: float) -> void:
	var mouse_pos:Vector2 = get_local_mouse_position()
	# print("%s | %s" % [mouse_pos])
	if visible and mouse_pos.x > 0 and mouse_pos.y > 0:
		($Viewport as Viewport).set("gui_disable_input", false)
	else:
		($Viewport as Viewport).set("gui_disable_input", true)