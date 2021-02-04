extends Node


var val:  String
var desc: String


func _ready():
	display_values()


func display_values()-> void:
	($Val as Label).text = val
	($Desc as Label).text = desc
