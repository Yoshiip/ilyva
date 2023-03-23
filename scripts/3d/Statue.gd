extends StaticBody

var i = 0.0

func _process(delta: float) -> void:
	i += delta
	$Planet.translation.y = 1.8 + sin(i) * 0.25
	$Ring.translation.y = 1.8 + sin(i) * 0.25
	$Ring.rotation_degrees.x = cos(i) * 10.0
	$Ring.rotation_degrees.y += delta * 15.0
