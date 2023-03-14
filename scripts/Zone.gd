extends Node2D

export var zone_id := "unnamed"
export var zone_name := "Unnamed"
export(String, "Morning", "Noon", "Evening") var time
export var start_scene := false
export var music_id := "night"

var in_dialogue = false

onready var PauseMenu := preload("res://prefabs/PauseMenu.tscn")
var pause_menu

func _ready() -> void:
	pause_menu = PauseMenu.instance()
	$Canvas/Container.add_child(pause_menu)
	if GameManager.scene_start_dialogue != zone_id && start_scene:
		var new_dialog = Dialogic.start(zone_id + '/Intro')
		GameManager.scene_start_dialogue = zone_id
		add_child(new_dialog)

	$Canvas/Container/ZoneName.text = zone_name
	$Canvas/Container/Time.text = time

func _process(_delta: float) -> void:
	
	for i in get_children():
		if i.get("dialog_node"):
			in_dialogue = true
			return
	in_dialogue = false
	
	pause_menu.can_pause = !in_dialogue

func play_music() -> void:
	MusicManager.start_music(music_id)


var light_off := false


func _on_TurnLight_toggled(button_pressed: bool) -> void:
	light_off = button_pressed
	if light_off:
		$Tween.interpolate_property($LightOff, "color", $LightOff.color, Color(0.25, 0.25, 0.25), 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(true)
		
	else:
		$Tween.interpolate_property($LightOff, "color", $LightOff.color, Color.white, 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(false)
	$Tween.start()
