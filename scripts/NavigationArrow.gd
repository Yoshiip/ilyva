extends Area2D


export var scene_name := ""


func interact() -> void:
	get_tree().current_scene.transition.transition_to_scene(str("res://scenes/", scene_name, ".tscn"))
