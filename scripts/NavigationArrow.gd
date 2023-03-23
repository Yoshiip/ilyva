extends Area2D


export var scene_name := ""


func interact() -> void:
	get_tree().current_scene.transition.transition_to_scene(str("res://scenes/", scene_name, ".tscn"))

func cursor_entered() -> void:
	$Icon.modulate.a = 1.0

func cursor_exited() -> void:
	$Icon.modulate.a = 0.5

