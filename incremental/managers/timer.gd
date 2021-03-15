extends Timer

signal endofyear()

var tick = 0

func _ready():
	tick = int(Settings.data_buffer.tick)
	wait_time = 0.25
	autostart = false
	one_shot = false
	process_mode = TIMER_PROCESS_PHYSICS
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "_on_timeout")])


func _on_timeout() -> void:
	tick += 1


func tick_to_date() -> String:
	if tick % 256 == 0:
		emit_signal("endofyear")
	# the Year is 8 Months long, each Month is 32 Days long
	var ticks:int = tick
	var year:int = ticks/256
	ticks %= 256
	var month:int = ticks/32
	ticks %= 32

	return "%02d/%d/%d" % [++ticks,month,year]
