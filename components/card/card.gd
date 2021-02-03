extends Control

func _ready() -> void:
	($S/V/T as Label).text = get_parent().name
