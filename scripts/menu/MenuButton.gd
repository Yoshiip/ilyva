extends Button

export var btn_label := ""
export var btn_icon : StreamTexture

func _ready() -> void:
	text = btn_label
	$bg_icon.texture = btn_icon

func _process(delta: float) -> void:
	if mouse_inside:
		$bg_icon.rect_rotation += delta * 90.0

var mouse_inside := false



func _on_Button_mouse_entered() -> void:
	mouse_inside = true

func _on_Button_mouse_exited() -> void:
	mouse_inside = false
