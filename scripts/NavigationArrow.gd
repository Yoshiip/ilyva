extends Area2D


export var scene_name := ""

export(int, 0, 99) var min_story_progress := 0
export var show_confirm := false

var popup : Panel

func _ready() -> void:
	get_parent().connect("story_progress_changed", self, "_story_progress_changed")
	if show_confirm:
		popup = load("res://prefabs/2d/Popup.tscn").instance()
		add_child(popup)


func interact() -> void:
	if min_story_progress > GameManager.story_progress:
		get_tree().current_scene.add_child(Dialogic.start(str("Shared/arrow_blocked")))
	else:
		if show_confirm:
			popup.show_popup("Aller au métro ?", scene_name)
		else:
			get_tree().current_scene.transition.transition_to_scene(str("res://scenes/", scene_name, ".tscn"))

func cursor_entered() -> void:
	$Icon.modulate.a = 1.0

func cursor_exited() -> void:
	$Icon.modulate.a = 0.5

