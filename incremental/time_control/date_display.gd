extends Label

func _ready() -> void:
	GameTimer.connect("timeout", self, "update_date")
	update_date()

func update_date() -> void:
	text = GameTimer.tick_to_date()
