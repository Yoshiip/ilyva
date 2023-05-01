extends KinematicBody2D


var vel := 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		vel = -500
	elif Input.is_action_pressed("ui_down"):
		vel = 500
	else:
		vel = 0
	move_and_slide(Vector2(0, vel))
