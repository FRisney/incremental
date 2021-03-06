extends Camera2D

export(float, 0.0, 1.0, 0.05) var z_factor
export(float) var min_zoom
export(float) var max_zoom
var pressed: bool = false
var tw: Tween = Tween.new()

func _ready() -> void:
	add_child(tw)

func _input(event):
	if !visible:
		pass
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
				pressed = !pressed

		if event.pressed and not tw.is_active() and zoom.x < max_zoom and zoom.x > min_zoom:
			change_zoom(event.button_index % BUTTON_WHEEL_UP)

	if event is InputEventMouseMotion and pressed:
		position -= event.relative * zoom.x


func change_zoom(z_out:bool) -> void:
	print(z_out)
	var target: float

	target = zoom.x + z_factor if not z_out else zoom.x - z_factor

	tw.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(target,target),
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_OUT)
	tw.start()
