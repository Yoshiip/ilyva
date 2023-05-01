extends CanvasLayer

onready var tween := $Transition/Tween

var active := false

func _ready() -> void:
	tween.interpolate_property($Transition.material, "shader_param/progress", 1.0, 0.0, 0.5)
	tween.start()

func transition_to_scene(scene_path : String) -> void:
	if !active:
		active = true
		tween.interpolate_property($Transition.material, "shader_param/progress", 0.0, 1.0, 0.5)
		tween.start()
		yield(get_tree().create_timer(0.5), "timeout")
	#	if scene_path == "res://scenes/3d/StationLevel.tscn" && !GameManager.settings.enable_3d:
		if scene_path == "subway":
			if GameManager.settings.enable_3d:
				scene_path = "res://extra/scenes/StationLevel.tscn"
			else:
				scene_path = "res://scenes/SubwaySimplified.tscn"
		if get_tree().change_scene(scene_path) != OK:
			$Transition.material.set_shader_param("progress", 0.0)
			printerr("Error")
