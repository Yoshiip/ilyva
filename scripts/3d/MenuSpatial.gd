extends Spatial

func _process(delta: float) -> void:
	$tunnel.translation.z += delta * 8.0
	if $tunnel.translation.z > 32:
		$tunnel.translation.z -= 16
