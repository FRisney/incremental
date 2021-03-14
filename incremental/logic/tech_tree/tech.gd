extends Panel

signal tech_unlock(tech_id)

export(int) var tech_id
export(Array, NodePath) var dependencies_path

var locked: bool = true
var done: bool = false
var dependencies: Array
var lines: Dictionary
var req: int = 0
onready var lk_but: Button = find_node("Unlock")

func _ready() -> void:
	Settings.call("enlist","tech", self.get_path())
	if dependencies_path.size() > 0:
		for dep_path in dependencies_path:
			var dep_node: Panel = get_node(dep_path)
			if dep_node.get("done"):
				req += 1
			dependencies.append(dep_node)
			dep_node.connect("tech_unlock", self, "on_unlock")
			create_path(dep_node)

		if req == dependencies.size():
			locked = false
	else:
		locked = false


	print(Settings.data_buffer.unlocked_techs.has(float(tech_id)))
	if Settings.data_buffer.unlocked_techs.has(float(tech_id)):
		print("unlocked %s" % tech_id)
		done = true

	set_button()

func _process(_delta: float) -> void:
	if dependencies.size() > 0:
		update_paths()


func set_button():
	if done:
		lk_but.disabled = true
		lk_but.mouse_default_cursor_shape = CURSOR_ARROW
	elif !locked:
		lk_but.disabled = false
		lk_but.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	else:
		lk_but.disabled = true
		lk_but.mouse_default_cursor_shape = CURSOR_FORBIDDEN
	

func update_paths():
	for dep in dependencies:
		var line:Line2D = lines[dep.get("tech_id")]
		if line == null:
			create_path(dep)
			continue
		line.set_point_position(0,rect_size/2)
		line.set_point_position(1,(dep.rect_size/2) + dep.rect_global_position - rect_global_position)


func create_path(target: Panel):
	var line: Line2D = Line2D.new()
	line.name = "%s" % target.get("tech_id")
	add_child(line)
	line.z_as_relative = false
	line.z_index = -1
	line.antialiased = true
	line.default_color = Color("#25252a")
	line.add_point(rect_size/2,0)
	line.add_point((target.rect_size/2) + target.rect_global_position - rect_global_position)
	lines[target.get("tech_id")] = line


func on_unlock(tech_unlocked):
	if dependencies.size() > 0:
		for dep in dependencies:
			if dep.get("tech_id") == tech_unlocked and dep.get("done"):
				req += 1
	if req == dependencies.size():
		locked = false
	print("%s recivied %s signal" % [ tech_id, tech_unlocked])
	set_button()


func _on_pressed() -> void:
	print("unlocked %s" % tech_id)
	done = true
	Settings.data_buffer.unlocked_techs.append(tech_id)
	set_button()
	emit_signal("tech_unlock",tech_id)

