extends Node

var res_a : int = 0

const resource_descriptor = {
	"res_a": "A",
}


func add_resource(res: String, inc: int = 1):
	set(res, get(res)+inc)
	print(get(res))

