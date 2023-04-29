extends Area2D



onready var camera: Camera2D = $"../Camera"
var current_area : Area2D
var tooltip

func _ready() -> void:
	yield(get_tree().current_scene, "ready")
	tooltip = get_tree().current_scene.tooltip

func _process(_delta: float) -> void:
	visible = !get_parent().in_dialogue
	position = lerp(position, get_global_mouse_position(), 0.1)
	if is_instance_valid(current_area) && !get_parent().in_dialogue:
		tooltip.visible = true
		tooltip.rect_position = current_area.position - tooltip.rect_size / 2.0 + Vector2(0, 48)
		if tooltip.bbcode_text != "[center][wave]Interact[/wave][/center]":
			tooltip.bbcode_text = "[center][wave]Interact[/wave][/center]"

	else:
		tooltip.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(current_area) && !get_parent().in_dialogue && Input.is_action_just_pressed("ui_accept"):
		current_area.interact()

func _on_Cursor_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		current_area = area
		if area.has_method("cursor_entered"):
			area.cursor_entered()

func _on_Cursor_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interaction"):
		if area.has_method("cursor_exited"):
			area.cursor_exited()
		current_area = null
