extends Node

# Base registry of various aspects of the game

enum Resources { A, B, C, D, E }
enum Buildings { A, B, C, D, E }

var resource_names = {
	Resources.A: 'A',
}

var resource_base_capacity = {
	Resources.A: 10,
}

var building_base_production = {
	Buildings.A: {
		Resources.A: 1,
	},
}

var building_base_consumption = {
	Buildings.A: { },
}

var building_base_cost = {
	Buildings.A: {
		Resources.A: 10,
	},
}

var building_base_storage = {
	Buildings.A: {
		Resources.A: 50,
	},
}

func game_data_loader(_file:String="res://defaults.json"):
	pass
