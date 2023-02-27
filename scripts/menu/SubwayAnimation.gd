extends Spatial


export var speed = 50.0

func _process(delta: float) -> void:
	translation.z += delta * 15.0
	if translation.z > 7:
		translation.z -= 7
