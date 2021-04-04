extends ViewportContainer

onready var vp: Viewport = $Viewport

func _process(_delta: float) -> void:
	var mouse_pos:Vector2 = get_local_mouse_position()
	if get_parent().get("visible") and mouse_pos.x > 0 and mouse_pos.y > 0:
		vp.set("gui_disable_input", false)
	else:
		if !Input.is_action_pressed('tech_cam_move'):
			vp.set("gui_disable_input", true)
