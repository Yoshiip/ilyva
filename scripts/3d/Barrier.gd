extends StaticBody


func _process(delta: float) -> void:
	var _enabled = get_tree().get_root().find_node("Player", true, false).translation.z > translation.z
	$CollisionShape.disabled = _enabled
	visible = !_enabled
