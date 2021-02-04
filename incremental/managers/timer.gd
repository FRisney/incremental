extends Node

signal ticked()

var increment = 1
var period_length = 0.25
var accumulator = -1
var tick = 0

func _process(delta) -> void:
	if not period_length:
		return

	if accumulator < period_length:
		accumulator += delta
		return

	accumulator = 0
	tick += increment
	emit_signal("ticked")
	# display.text = tick_to_date(tick)


func tick_to_date() -> String:
	# the Year is 8 Months long, each Month is 32 Days long
	var ticks:int = tick
	var year:int = ticks/256
	ticks %= 256
	var month:int = ticks/32
	ticks %= 32

	return "%02d/%d/%d" % [++ticks,month,year]


func _on_change_time_speed(state) -> void:
	if (state):
		period_length = 0
		print("Pause")
	else:
		period_length = 0.25
		print("Play")
