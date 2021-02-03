extends RichTextLabel


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("signal: %s (%s)" % [name,get_node("../TimeControl").connect("tickdate", self, "_on_ticked")])


func _on_ticked(ticks) -> void:
	add_text(get_node("../TimeControl").tick_to_date(ticks) + "\n")
	if get_line_count() > 250:
		clear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
