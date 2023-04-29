extends ColorRect

func _ready() -> void:
	$Tween.interpolate_property(self.material, "shader_param/progress", 1.0, 0.0, 0.5)
	$Tween.start()

func transition_to_scene(scene_path : String) -> void:
	$Tween.interpolate_property(self.material, "shader_param/progress", 0.0, 1.0, 0.5)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
#	if scene_path == "res://scenes/3d/StationLevel.tscn" && !GameManager.settings.enable_3d:
	if scene_path == "subway":
		scene_path = "res://scenes/SubwaySimplified.tscn"
	if get_tree().change_scene(scene_path) != OK:
		material.set_shader_param("progress", 0.0)
		printerr("Error")
