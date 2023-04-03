extends StaticBody


func _process(delta: float) -> void:
	var _enabled = get_tree().current_scene.get_node("Player").translation.z > translation.z
	$CollisionShape.disabled = _enabled
	visible = !_enabled
