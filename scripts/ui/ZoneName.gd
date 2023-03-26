extends Label

onready var tween


func play_animation(station_name : String) -> void:
	if tween == null:
		tween = Tween.new()
		add_child(tween)
	text = station_name.to_upper()
	add_child(tween)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1)
	tween.interpolate_property($Circle, "rect_scale", Vector2.ONE, Vector2.ONE * 0.25, 1.0)
	tween.interpolate_property(get("custom_fonts/font"), "extra_spacing_char", 32.0, 0.0, 1)
	tween.start()
	yield(get_tree().create_timer(3.0), "timeout")
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2.0)
	tween.interpolate_property(get("custom_fonts/font"), "extra_spacing_char", 0.0, 32.0, 2.0)
	tween.interpolate_property($Circle, "rect_scale", Vector2.ONE * 0.25, Vector2.ONE * 1.0, 2.0)
	tween.start()
