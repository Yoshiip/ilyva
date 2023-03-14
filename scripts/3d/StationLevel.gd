extends Spatial

onready var map: Spatial = $Canvas/Container/MinimapContainer/Viewport/Map



onready var PauseMenu := preload("res://prefabs/PauseMenu.tscn")
var pause_menu

func _ready() -> void:
	pause_menu = PauseMenu.instance()
	$Canvas/Container.add_child(pause_menu)



func _process(delta: float) -> void:
#	for i in get_tree().get_nodes_in_group("Subway"):
#		if i.player_inside:
	map.visible = true
	map.get_node("Subway").progress = $Canvas/Container/ViewportContainer/Viewport/MovingSubway.offset
#			return
#	map.visible = false
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
