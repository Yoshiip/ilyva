extends Control

var m : Vector2

func _ready() -> void:
	$Icon.material = $Icon.material.duplicate()

func _process(_delta: float) -> void:
	var mouse = ((get_global_mouse_position() - $Icon.rect_global_position - rect_size / 2.0) * 0.2).limit_length(25)
	m = lerp(m, mouse, 0.1)
	$Icon.material.set_shader_param("y_rot", m.x)
	$Icon.material.set_shader_param("x_rot", -m.y)
