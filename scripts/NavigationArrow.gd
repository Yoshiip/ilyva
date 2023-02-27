extends Area2D


export var scene_name := ""


func interact() -> void:
	get_tree().change_scene(scene_name)
