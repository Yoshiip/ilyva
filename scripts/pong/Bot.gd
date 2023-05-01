extends KinematicBody2D


func _process(delta: float) -> void:
	var _vel = 0
	if get_parent().get_node("Ball").position.y > position.y:
		_vel = 150
	else:
		_vel = -150
	move_and_slide(Vector2(0, _vel))
