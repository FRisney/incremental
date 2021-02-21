tool
extends Panel

signal tech_unlock(tech_id)

export(int) var tech_id
export(Array, NodePath) var dependencies_path
var dependencies: Array
var lines: Dictionary
export(bool) var locked
export(bool) var done


func _ready() -> void:
	if dependencies_path.size() > 0:
		($Unlock as Button).disabled = true
		for dep_path in dependencies_path:
			var dep_node: Panel = get_node(dep_path)
			dependencies.append(dep_node)
			print("signal: %s (%s)" % [name,dep_node.connect("tech_unlock", self, "on_unlock")])
			create_path(dep_node)
	else:
		locked = false


func _process(_delta: float) -> void:
	if dependencies.size() > 0:
		update_paths()


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
	var req: int = 0
	if dependencies.size() > 0:
		for dep in dependencies:
			if dep.get("tech_id") != tech_unlocked:
				pass
			if dep.get("done"):
				req += 1
	if req == dependencies.size():
		locked = false
		($Unlock as Button).disabled = false


func _on_pressed() -> void:
	done = true
	($Unlock as Button).disabled = true
	emit_signal("tech_unlock",tech_id)

