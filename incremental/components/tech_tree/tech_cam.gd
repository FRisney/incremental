extends Camera2D

var pressed: bool = false
var tw: Tween = Tween.new()

func _ready() -> void:
	add_child(tw)

func _input(event):
	if !visible:
		pass
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_RIGHT:
				pressed = !pressed
			BUTTON_WHEEL_UP:
				if zoom.x > 1.0:
					change_zoom(false)

			BUTTON_WHEEL_DOWN:
				if zoom.x < 2.2:
					change_zoom(true)
	if event is InputEventMouseMotion and pressed:
		position -= event.relative * zoom.x


func change_zoom(z_in) -> void:
	var _factor: Vector2 = Vector2(0.3,0.3)
	var target: Vector2
	if z_in:
		target = zoom + _factor
	else:
		target = zoom - _factor
	tw.interpolate_property(
		self,
		"zoom",
		zoom,
		target,
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_OUT)
	tw.start()
