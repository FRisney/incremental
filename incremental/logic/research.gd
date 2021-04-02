extends "res://logic/resource.gd"


onready var label: Label = $Panel/Label


func _ready():
	GameTimer.connect('timeout',self,'_on_ticked')


func _on_ticked() -> void:
	if GameTimer.get('tick') % 32 == 0:
		current += 1 if current + 1 <= capacity else 0
	label.text = "Research Points: %d" % current

