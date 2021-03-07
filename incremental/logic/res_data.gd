extends Resource
class_name ResData

export(Array, Dictionary) var extractors # {
	# 	id: int
	# 	builded: int
	# 	cost: string - math expr
	# 	production: string - math expr
	# }
export(Array, Dictionary) var storages # {
	# 	id: int
	# 	builded: int
	# 	cost: string - math expr
	# 	stores: string - math expr
	# }
export var type: String
export var manual_extract:int = 0
export var capacity:int = 15
export var current: int = 0
