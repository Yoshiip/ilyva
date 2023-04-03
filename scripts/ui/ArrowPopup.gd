extends Panel

var scene_path : String

onready var tween := Tween.new()

func _ready() -> void:
	visible = false
	add_child(tween)

func show_popup(text : String, s_path : String) -> void:
	visible = true
	$Label.text = text
	tween.interpolate_property(self, "rect_position", Vector2(-160, -100), Vector2(-160, -180), 0.5)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.5)
	tween.start()
	scene_path = s_path



func _on_Yes_pressed() -> void:
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5)
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	print(scene_path)
	get_tree().current_scene.transition.transition_to_scene(str("res://scenes/", scene_path, ".tscn"))

func _on_No_pressed() -> void:
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5)
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	visible = false
