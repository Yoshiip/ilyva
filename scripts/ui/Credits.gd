extends CanvasLayer

func _process(delta: float) -> void:
	if $Container.rect_position.y > -3550:
		$Container.rect_position.y -= delta * 50.0


func _on_Menu_pressed() -> void:
	get_tree().change_scene("res://scenes/Menu.tscn")
