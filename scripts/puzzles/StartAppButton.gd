extends Button


func _on_Button_mouse_entered() -> void:
	$Icon.texture.region.position.x = 16

func _on_Button_mouse_exited() -> void:
	$Icon.texture.region.position.x = 0
