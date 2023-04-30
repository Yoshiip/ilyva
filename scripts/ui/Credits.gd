extends CanvasLayer

func _process(delta: float) -> void:
	if $Container/Credits.rect_position.y > -3550:
		$Container/Credits.rect_position.y -= delta * 65.0
		$Container/Background.rect_position.y -= delta * 32.0

func _on_Menu_pressed() -> void:
	get_tree().change_scene("res://scenes/Menu.tscn")
