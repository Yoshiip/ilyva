extends Node2D


var pause_menu

export var puzzle : Resource
onready var tween := Tween.new()

func _ready() -> void:
	add_child(tween)
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	$Canvas/Container.add_child(pause_menu)


onready var pattern: Sprite = $Wallpaper/Pattern

func _process(delta: float) -> void:
	var time = Time.get_time_dict_from_system()
	if time.second % 2 == 0:
		$Canvas/Container/Footer/Time.text = "%02d:%02d" % [time.hour, time.minute]
	else:
		$Canvas/Container/Footer/Time.text = "%02d %02d" % [time.hour, time.minute]
	$LightMask.position = lerp($LightMask.position, get_global_mouse_position(), delta * 2.0)
	pattern.position.x += delta * 50.0
	pattern.position.y += delta * 50.0
	if pattern.position.x > 1178:
		pattern.position.x -= 1178
	if pattern.position.y > 850:
		pattern.position.y -= 850

func change_background_color(color : Color) -> void:
	tween.interpolate_property($Wallpaper, "modulate", $Wallpaper.modulate, color, 3.0)
	tween.start()
