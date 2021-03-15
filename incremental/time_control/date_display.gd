extends Label

func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("timeout", self, "update_date")])
	update_date()

func update_date() -> void:
	text = GameTimer.tick_to_date()
