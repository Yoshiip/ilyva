extends Camera2D

var max_drag := 0

func _ready() -> void:
	get_viewport().connect("size_changed", self, "_size_changed")

func _process(delta: float) -> void:
	max_drag = (get_parent().image_size - get_viewport().size.x) / 2.0
	if get_parent().in_dialogue:
		return
	var mouse_x = get_viewport().get_mouse_position().x
	if mouse_x < 200 && position.x > -max_drag:
		position.x -= delta * 500.0
	elif mouse_x > get_viewport().size.x - 200 && position.x < max_drag:
		position.x += delta * 500.0

func _size_changed() -> void:
	zoom.x = 1080.0 / get_viewport().size.y
	zoom.y = 1080.0 / get_viewport().size.y
