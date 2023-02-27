extends Area2D

export var dialogue_name := ""


func interact() -> void:
	var new_dialog = Dialogic.start(dialogue_name)
	get_tree().current_scene.add_child(new_dialog)
