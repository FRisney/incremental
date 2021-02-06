extends Button

export(String) var res_type
var accumulator:int = 0

func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "_on_tick")])
	print("signal: %s (%s)" % [name,connect("pressed", self, "_on_press")])

func _on_tick():
	accumulator = 0

func _on_press():
	accumulator += 1
	if accumulator > 2:
		return
	Storage.add_resource(res_type, accumulator)
# func display_content(data):


