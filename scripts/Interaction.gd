extends Area2D

export var character_name := ""
export var timeline_id := 0

func _ready() -> void:
	if character_name == "":
		character_name = name


func interact() -> void:
	var new_dialog = Dialogic.start(str(get_tree().current_scene.zone_id, "/" + character_name +"/", timeline_id))
	get_tree().current_scene.add_child(new_dialog)
