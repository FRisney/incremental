extends Label

func _ready() -> void:
	print("date_display connect: %s" % get_node("/root/BG/TimeControl").connect("ticked",self,"update_date"))

func update_date(date) -> void:
	text = "%02d/%d/%d" % [date[0],date[1],date[2]]
