extends Control

class_name TimeController

signal tickdate(date)
signal ticked()

const PERIOD_LEN_SHORT = 0.001
const PERIOD_LEN_MEDIUM = 0.100
const PERIOD_LEN_LONG = 0.250

const TIME_INC_YEAR = 256
const TIME_INC_MONTH = 32
const TIME_INC_DAY = 1

var increment = TIME_INC_DAY
var accumulator = -1
var tick = 0
var period_length = PERIOD_LEN_LONG

onready var display = $Controls/Display


# func _ready() -> void:
# 	add_user_signal("tickdate")
# 	add_user_signal("ticked")


func _process(delta) -> void:
	if period_length < PERIOD_LEN_SHORT:
		return

	if accumulator < period_length:
		accumulator += delta
		return

	accumulator = 0
	tick += increment
	emit_signal("ticked")
	emit_signal("tickdate",tick)
	display.text = tick_to_date(tick)


func tick_to_date(ticks:int) -> String:
	var year:int = (ticks/TIME_INC_YEAR)
	ticks %= TIME_INC_YEAR
	var month:int = (ticks/TIME_INC_MONTH)
	ticks %= (TIME_INC_MONTH) + 1

	return "%02d/%d/%d" % [ticks,month,year]


func _on_change_time_speed(type) -> void:
	print(type)
	match type:
		false:
			period_length = PERIOD_LEN_LONG
		true:
			period_length = 0
