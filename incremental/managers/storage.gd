extends Node

var resources: Dictionary

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
	var rmax = resources[res].get("res_max")
	var current = resources[res].get("res_cur")

	if rmax - current == 0:
		pass

	if rmax > current:
		current += inc

	if current > rmax:
		current = rmax

	resources[res].set("res_cur",current)

func sub_resource(res: int, ammount: int):
	resources[res].current -= ammount
