extends Panel



func change_settings_button(checked_name : String) -> void:
	for i in $Scroll/Container/Graphics/Container/GraphicsContainer.get_children():
		if i.name == checked_name:
			i.get_node("Checkbox").visible = true
			i.get_node("Checkbox").checked = true
		else:
			i.get_node("Checkbox").checked = false
			i.get_node("Checkbox").visible = false
	if get_tree().current_scene.get("update_game_quality"):
		get_tree().current_scene.update_game_quality()


func _on_Low_pressed() -> void:
	GameManager.settings["3d_quality"] = 0
	change_settings_button("Low")


func _on_Medium_pressed() -> void:
	GameManager.settings["3d_quality"] = 1
	change_settings_button("Medium")


func _on_High_pressed() -> void:
	GameManager.settings["3d_quality"] = 2
	change_settings_button("High")

func show() -> void:
	visible = true
	$Tween.interpolate_property(self, "rect_position:x", 1280, 640, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 0, 1, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func hide() -> void:
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.camera.switch_camera()
	$Tween.interpolate_property(self, "rect_position:x", 640, 1280, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1, 0, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	visible = false

func _on_Return_pressed() -> void:
	hide()


func _on_Fullscreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Timer_timeout() -> void:
	$TopIcon1.rect_rotation = rand_range(-45, 45)
	$TopIcon2.rect_rotation = rand_range(-45, 45)


func _on_Disable3D_pressed() -> void:
	GameManager.settings.disable_3d = !GameManager.settings.disable_3d

func _ready() -> void:
	get_viewport().connect("size_changed", self, "window_size_changed")

func window_size_changed() -> void:
	print(rect_size.x)
	$Scroll/Container.rect_min_size.x = rect_size.x - 48
