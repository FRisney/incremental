extends Panel

signal tech_unlocked(tech_id)

enum TECH_STATUS {
	AVAILABLE = 0
	DONE = 1
	MISSING_RESOURCES = 2
	MISSING_TECHS = 4
}

export(String) var tech_id
export(Array, String) var dependencies_ids
export var costs: Dictionary
# {
# 	"res": amount,
# 	...
# }

var status:int = TECH_STATUS.AVAILABLE
var dependencies: Array
var lines: Dictionary
var req: Array = [[],{}]
# [
# 	[ id, ...] - done dependencies
# 	{
# 		resource_id: bool minimum quantity not met,
# 		...
# 	}
# ]
onready var lk_but: Button = find_node("Unlock")

func _ready() -> void:
	GameTimer.connect("timeout",self, "_on_ticked")
	Settings.call("enlist","tech", tech_id, self.get_path())
	if dependencies_ids.size() > 0:
		for id in dependencies_ids:
			var dep_node: Panel = Settings.call("get_node_by_ref",'tech',str(id))
			if dep_node.get("status") == TECH_STATUS.DONE:
				req[0].append(dep_node.get("tech_id"))
			dependencies.append(dep_node)
			dep_node.connect("tech_unlocked", self, "on_unlock")
			create_path(dep_node)
	if Settings.data_buffer.unlocked_techs.has(tech_id):
		status = TECH_STATUS.DONE
	if is_missing_resources():
		status = TECH_STATUS.MISSING_RESOURCES
	if is_missing_dependencies():
		status = TECH_STATUS.MISSING_TECHS
	update_button()

func _on_ticked():
	if status != TECH_STATUS.DONE:
		status = TECH_STATUS.AVAILABLE
		if is_missing_resources():
			status = TECH_STATUS.MISSING_RESOURCES
		if is_missing_dependencies():
			status = TECH_STATUS.MISSING_TECHS
		update_button()

func update_button():
	if status == TECH_STATUS.DONE:
		lk_but.disabled = true
		lk_but.mouse_default_cursor_shape = CURSOR_ARROW
	elif status == TECH_STATUS.MISSING_RESOURCES or status == TECH_STATUS.MISSING_TECHS:
		lk_but.disabled = true
		lk_but.mouse_default_cursor_shape = CURSOR_FORBIDDEN
	else:
		lk_but.disabled = false
		lk_but.mouse_default_cursor_shape = CURSOR_POINTING_HAND
	

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
			var id = dep.get("tech_id")
			if id == tech_unlocked and dep.get("status") == TECH_STATUS.DONE:
				req[0].append(id)
	if is_missing_resources():
		status = TECH_STATUS.MISSING_RESOURCES
	if is_missing_dependencies():
		status = TECH_STATUS.MISSING_TECHS


func _on_pressed() -> void:
	for res in costs:
		Settings.call('consume_resource', res, costs[res])
	status = TECH_STATUS.DONE
	Settings.call("unlock_tech",tech_id)
	update_button()
	emit_signal("tech_unlocked",tech_id)


func is_missing_resources() -> bool:
	if status == TECH_STATUS.DONE:
		return false
	var cost_not_met:bool=true
	for res in costs:
		req[1][res] = costs[res] > Settings.call("get_res_current", res)
		cost_not_met = cost_not_met and req[1][res]
	return cost_not_met


func is_missing_dependencies() -> bool:
	if status == TECH_STATUS.DONE or dependencies_ids.size() == 0:
		return false
	return dependencies_ids.size() != req[0].size()
