extends Node


# Declare member variables here. Examples:

var val:  String
var desc: String

func _awake():
	val = ($Val as Label).text
	desc = ($Desc as Label).text


func displayValues()-> void:
	($Val as Label).text = val
	($Desc as Label).text = desc
