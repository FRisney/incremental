extends Node

const resources = {
	Settings.Resources.A: {
		'name': 'A',
		'max': 100,
		'current': 0,
	},

}

func get_res_name(res:int) -> String:
	return resources[res].name

func get_current(res: int) -> int:
	if resources.has(res):
		return resources[res].current
	else:
		return -1

func get_max(res: int) -> int:
	if resources.has(res):
		return resources[res].max
	else:
		return -1

func add_resource(res: int, inc: int = 1):
	var rmax = resources[res].max
	var current = resources[res].current

	if rmax - current == 0:
		pass

	if rmax > current:
		current += inc

	if current > rmax:
		current = rmax

	resources[res].current = current

func sub_resource(res: int, ammount: int):
	resources[res].current -= ammount
