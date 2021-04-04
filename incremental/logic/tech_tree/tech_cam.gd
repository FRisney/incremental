extends Camera2D

export(float, 0.0, 1.0, 0.05) var z_factor
export(float) var min_zoom
export(float) var max_zoom
export(float) var zoom_speed
var tw: Tween = Tween.new()
var new_pos: Vector2
var saved_pos: Vector2
var limits: Rect2

func _ready() -> void:
	add_child(tw)
	var reference_rect: ReferenceRect = get_node("../TechTree")
	limits = Rect2(
			reference_rect.rect_position,
			reference_rect.rect_size
		)

func _process(_delta):
	if !get_parent().get_parent().get_parent().get("visible"):
		pass
	var target: float = 0
	if Input.is_action_just_released("tech_cam_zoom_in") or Input.is_action_just_released("tech_cam_zoom_out"):
		if Input.is_action_just_released("tech_cam_zoom_in"):
			target = -1
		elif Input.is_action_just_released("tech_cam_zoom_out"):
			target = 1
	if target != 0:
		target = zoom.x + (z_factor*zoom.x*target)
		print(target)
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

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed('tech_cam_move'):
		var horz_move:float = position.x - event.relative.x * zoom.x
		var vert_move:float = position.y - event.relative.y * zoom.y
		if limits.has_point(Vector2(horz_move, vert_move)):
			position = Vector2(horz_move, vert_move)
		elif limits.has_point(Vector2(horz_move, position.y)):
			position = Vector2(horz_move, position.y)
		elif limits.has_point(Vector2(position.x, vert_move)):
			position = Vector2(position.x, vert_move)
