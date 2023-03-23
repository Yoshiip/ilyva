extends PathFollow2D

func _process(delta: float) -> void:
	offset += delta * 50.0
	print(offset)
