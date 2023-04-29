extends Panel

func _ready() -> void:
	if get_viewport().connect("size_changed", self, "window_size_changed") != OK:
		print("error while connecting")
	$Tween.interpolate_property(self, "rect_position:x", get_viewport().size.x, get_viewport().size.x / 2.0, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 0, 1, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	window_size_changed()

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

func close() -> void:
	$Tween.interpolate_property(self, "rect_position:x", get_viewport().size.x / 2.0, get_viewport().size.x, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a", 1, 0, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func _on_Return_pressed() -> void:
	close()


func _on_Fullscreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Timer_timeout() -> void:
	$TopIcon1.rect_rotation = rand_range(-45, 45)
	$TopIcon2.rect_rotation = rand_range(-45, 45)




func window_size_changed() -> void:
	$Scroll/Container.rect_min_size.x = rect_size.x - 48


func _on_Enable3D_pressed() -> void:
	GameManager.settings.enable_3d = !GameManager.settings.enable_3d
	
	for i in $"Scroll/Container/3D/Container".get_children():
		if !(i.name in ["Header", "Enable3D"]):
			i.visible = GameManager.settings.enable_3d
	yield(get_tree(), "idle_frame")
	$"Scroll/Container/3D".rect_min_size.y = $"Scroll/Container/3D/Container".rect_size.y
