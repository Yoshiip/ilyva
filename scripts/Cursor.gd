extends Area2D


var current_area : Area2D
func _process(delta: float) -> void:
	position = lerp(position, get_global_mouse_position(), 0.1)
	if Input.is_action_just_pressed("ui_accept") && is_instance_valid(current_area) && !get_parent().in_dialogue:
		current_area.interact()

func _on_Cursor_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		current_area = area

func _on_Cursor_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		current_area = null
