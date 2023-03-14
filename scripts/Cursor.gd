extends Area2D



onready var camera: Camera2D = $"../Camera"


var current_area : Area2D
func _process(_delta: float) -> void:
	visible = !get_parent().in_dialogue
	position = lerp(position, get_global_mouse_position(), 0.1)
	if is_instance_valid(current_area) && !get_parent().in_dialogue:
		$"%Tooltip".visible = true
		$"%Tooltip".rect_position = current_area.position - $"%Tooltip".rect_size / 2.0 + Vector2(0, 48)
		if $"%Tooltip".bbcode_text != "[center][wave]Interact[/wave][/center]":
			$"%Tooltip".bbcode_text = "[center][wave]Interact[/wave][/center]"
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
