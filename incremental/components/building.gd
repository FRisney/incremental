extends Button

export(Settings.BuildingType) var build_type
export(Settings.Resources) var res_type
var button_text: String

func _ready() -> void:
	print("signal: %s (%s)" % [name,connect("pressed", self, "_on_press")])
	match (build_type):
		Settings.BuildingType.EXTRACTOR:
			button_text = 'Extractor'


func _on_press():
	if Builder.new_building(build_type, res_type):
		text = "%s [%s]" % [button_text,Builder.get_building_count(build_type,res_type)]
