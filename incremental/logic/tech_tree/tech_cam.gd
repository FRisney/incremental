extends Camera2D

export(float, 0.0, 1.0, 0.05) var z_factor
export(float) var min_zoom
export(float) var max_zoom
export(float) var zoom_speed
var pressed: bool = false
var tw: Tween = Tween.new()
var new_pos: Vector2
var limits: Rect2

func _ready() -> void:
	add_child(tw)
	var reference_rect: ReferenceRect = get_node("../TechTree")
	limits = Rect2(
			reference_rect.rect_position,
			reference_rect.rect_size
		)

func _input(event):
	if !visible:
		pass
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			pressed = event.pressed

		elif event.button_index == BUTTON_WHEEL_DOWN or event.button_index == BUTTON_WHEEL_UP:
			var target: float
			target = zoom.x + (z_factor*zoom.x) if BUTTON_WHEEL_UP % event.button_index else zoom.x - (z_factor*zoom.x)
			if event.pressed:
				if target > max_zoom:
					target = max_zoom
				elif target < min_zoom:
					target = min_zoom
				else:
					tw.interpolate_property(
						self,
						"zoom",
						zoom,
						Vector2(target,target),
						zoom_speed,
						Tween.TRANS_SINE,
						Tween.EASE_OUT)
					tw.start()


	if event is InputEventMouseMotion and pressed:
		new_pos = position - event.relative * zoom.x
		if limits.has_point(new_pos):
			position = new_pos
