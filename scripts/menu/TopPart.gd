extends Control

var i = 0.0

func _process(delta: float) -> void:
	$GreenDot.rect_position.x = 665 + (sin(i) * 30.0)
	$BlueDot.rect_position.x = 696 + (cos(i) * 30.0)
	$RedDot.rect_position.y = 32 + (sin(i) * 5.0)
	i += delta
