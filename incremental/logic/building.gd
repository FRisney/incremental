extends Resource
class_name BuildingData

export var cost: String
export var production: String
export var storage: String
export var builded: int

onready var exp_cost: Expression = Expression.new()
onready var exp_prod: Expression = Expression.new()
onready var exp_stor: Expression = Expression.new()


func _ready() -> void:
	 exp_cost.parse(cost, ["x"])
	 exp_prod.parse(production, ["x"])
	 exp_stor.parse(storage, ["x"])


# func get_cost() -> int:
# 	 return 0


# func get_production() -> int:
# 	 return 0


# func get_storage() -> int:
# 	 return 0

