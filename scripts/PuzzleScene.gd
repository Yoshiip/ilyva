extends Node2D

var pause_menu

func _ready() -> void:
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	$Canvas/Container.add_child(pause_menu)

func _process(delta: float) -> void:
	$LightMask.position = lerp($LightMask.position, get_global_mouse_position(), delta * 2.0)
	$Pattern.position.x += delta * 50.0
	$Pattern.position.y += delta * 50.0
	if $Pattern.position.x > 1178:
		$Pattern.position.x -= 1178
	if $Pattern.position.y > 850:
		$Pattern.position.y -= 850
