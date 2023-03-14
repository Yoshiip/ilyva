extends Area2D


export var scene_name := ""


func interact() -> void:
	if get_tree().change_scene(scene_name) != OK:
		printerr("Error")
