extends Control

export(Settings.Resources) var res_type
export(int) var manual_extract = 0

onready var title: Label = get_node("Scroll/VBox/Title")
onready var res_qtt: Label = get_node("Scroll/VBox/Total/Val")

var res_max:int = Settings.get("resource_base_capacity")[res_type]
var res_cur: int = 0

func _ready() -> void:
	if !manual_extract:
		($Scroll/VBox/Extract as Button).visible = false
	Storage.get("resources")[res_type] = self
	title.text = Settings.get("resource_names")[res_type]


func _process(_delta: float) -> void:
	res_qtt.text = "%s" % res_cur

func _on_extract():
	print("resource_names")
	if !GameTimer.is_stopped():
		Storage.add_resource(res_type,manual_extract)
		# if res_max - res_cur == 0:
		# 	pass
		# if res_max > res_cur:
		# 	res_cur += 1
		# if res_cur > res_max:
		# 	res_cur = res_max

func _on_build_extractor():
	pass


func _on_build_storage():
	pass
