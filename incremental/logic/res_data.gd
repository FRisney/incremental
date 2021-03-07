extends Resource
class_name ResData

export(Array, Dictionary) var extractors # {
	# 	builded: int
	# 	cost: string - math expr
	# 	production: string - math expr
	# }
export(Array, Dictionary) var storages # {
	# 	builded: int
	# 	cost: string - math expr
	# 	stores: string - math expr
	# }
export(Settings.ResTypes) var type
export var manual_extract:int = 0
export var capacity:int = 15
export var current: int = 0