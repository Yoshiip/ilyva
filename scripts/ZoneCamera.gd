extends Camera2D

export var max_drag := 102

func _process(delta: float) -> void:
	var mouse_x = get_viewport().get_mouse_position().x
	if mouse_x < 200 && position.x > -max_drag:
		position.x -= delta * 200.0
	elif mouse_x > get_viewport().size.x - 200 && position.x < max_drag:
		position.x += delta * 200.0
