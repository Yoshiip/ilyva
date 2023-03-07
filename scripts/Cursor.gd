extends Area2D



onready var camera: Camera2D = $"../Camera"

var current_area : Area2D
func _process(delta: float) -> void:
	position = lerp(position, get_global_mouse_position(), 0.1)
	if is_instance_valid(current_area) && !get_parent().in_dialogue:
		$"%Tooltip".visible = true
		$"%Tooltip".rect_position = current_area.position - Vector2(0, 32) + get_viewport().size / 2.0 - camera.position
		$"%Tooltip".text = "Interact"
		if Input.is_action_just_pressed("ui_accept"):
			current_area.interact()
	else:
		$"%Tooltip".visible = false

func _on_Cursor_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		current_area = area

func _on_Cursor_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		current_area = null
