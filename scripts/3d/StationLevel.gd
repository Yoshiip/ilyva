extends Spatial

onready var map: Panel = $Canvas/Container/Minimap

var pause_menu

func _ready() -> void:
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	$Canvas/Container.add_child(pause_menu)



func _process(_delta: float) -> void:
	$Canvas/Container/Label.text = str(Engine.get_frames_per_second(), "fps")
	for i in get_tree().get_nodes_in_group("Subway"):
		if i.player_inside:
			map.visible = true
			map.get_node("Container/Viewport/Map/Subway").progress = $MovingSubway.offset
			return
	map.visible = false
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
