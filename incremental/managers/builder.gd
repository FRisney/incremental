extends Node

var extractors:Dictionary = {
	Settings.Resources.A: {
		"quantity": 0,
		"extraction_time": {
			"total": 2,
			"left": 0,
		},
		"base_cost": {
			Settings.Resources.A: 2,
		},
		"base_production": {
			Settings.Resources.A: 1,
		},
	},
}

func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "_on_tick")])

func _on_tick() -> void:
	for res in extractors:
		for res_prod in extractors[res].base_production:
			if extractors[res].extraction_time.left == extractors[res].extraction_time.total:
				Storage.add_resource(res,extractors[res].base_production[res_prod] * extractors[res].quantity)
				extractors[res].extraction_time.left = 0
			else:
				extractors[res].extraction_time.left += 1


func get_building_count(type:int=-1,prod:int=-1) -> Dictionary:
	match (type):
		Settings.BuildingType.EXTRACTOR:
			if prod != -1:
				return extractors[prod].quantity
			else:
				var dict:Dictionary = {}
				for prod in extractors:
					dict[prod] = extractors[prod].quantity
				return dict
		_:
			return {}

func new_building(type:int,product:int) -> bool:
	if type == Settings.BuildingType.EXTRACTOR:
		var base_costs:Dictionary = extractors[product].base_cost
		var costs_met:int = 0
		var res_costs:Dictionary = {}
		var quantity:int = extractors[product].quantity

		for base_res_cost in base_costs:
			var base_cost = base_costs[base_res_cost]
			var cost = ceil( pow( quantity, base_cost ) )
			if cost < 1 :
				cost = 1
			res_costs[base_res_cost] =  cost
			print("%s extractor costs %s" % [Storage.get_res_name(base_res_cost),res_costs])
			if Storage.get_current(base_res_cost) >= cost:
				print("cost met %s/%s" % [res_costs,Storage.resources])
				costs_met += 1;

		if costs_met == len(base_costs):
			for res in res_costs:
				Storage.sub_resource(res, res_costs[res])
			extractors[product].quantity += 1
			return true
		else:
			print("Not Enough resources %s/%s" % [res_costs,Storage.resources])
			return false
	else:
		return false
