extends RichTextLabel


func _ready() -> void:
	print("signal: %s (%s)" % [name,GameTimer.connect("ticked", self, "_on_ticked")])


func _on_ticked() -> void:
	add_text(GameTimer.tick_to_date())
	newline()
	if get_line_count() > 250:
		clear()