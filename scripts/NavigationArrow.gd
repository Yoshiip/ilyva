extends Area2D


export var scene_name := ""

export var need_condition_to_show := false

export var condition : String
export var show_dialog : String
export var show_confirm := false

var popup : Panel

func _ready() -> void:
	print(need_condition_to_show && !GameManager.progress[get_tree().current_scene.zone_id].get(condition))
	print(!GameManager.progress[get_tree().current_scene.zone_id].get(condition))
	if need_condition_to_show && !GameManager.progress[get_tree().current_scene.zone_id].get(condition):
		queue_free()
		
#	if get_parent().connect("story_progress_changed", self, "_story_progress_changed") != OK:
#		print("error while connecting")
	if show_confirm:
		popup = load("res://prefabs/2d/Popup.tscn").instance()
		add_child(popup)


func interact() -> void:
	if condition != "" && !GameManager.progress[get_tree().current_scene.zone_id].get(condition):
		get_tree().current_scene.add_child(Dialogic.start(str("Shared/arrow_blocked")))
	else:
#		if show_confirm:
		if scene_name == "subway":
			popup.show_popup("Aller au métro ?", scene_name)
		else:
			get_tree().current_scene.transition.transition_to_scene(str("res://scenes/", scene_name, ".tscn"))

func cursor_entered() -> void:
	$Icon.modulate.a = 1.0

func cursor_exited() -> void:
	$Icon.modulate.a = 0.5

