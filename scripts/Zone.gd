extends Node2D

export var zone_id := "unnamed"
export var zone_name := "Unnamed"
export(String, "Morning", "Noon", "Evening") var time
export var start_scene := false
export var music_id := "night"

var in_dialogue = false

export var image_size := 2784

onready var PauseMenu := preload("res://prefabs/PauseMenu.tscn")
var pause_menu

var tooltip : RichTextLabel
var transition : ColorRect
var cursor : Area2D
var canvas : CanvasLayer

var background_blur : Sprite

onready var scene_light := CanvasModulate.new()
onready var tween := Tween.new()

func _ready() -> void:
	$Camera.limit_left = -image_size / 2
	$Camera.limit_right = image_size / 2
	pause_menu = PauseMenu.instance()
	
	canvas = preload("res://prefabs/2d/GameCanvas.tscn").instance()
	add_child(canvas)
	
	tooltip = preload("res://prefabs/Tooltip.tscn").instance()
	add_child(tooltip)
	
	transition = preload("res://prefabs/Transition.tscn").instance()
	get_node("Canvas/Container").add_child(transition)
	
	cursor = preload("res://prefabs/Cursor.tscn").instance()
	add_child(cursor)
	
	add_child(tween)
	
	add_child(scene_light)
	canvas.get_node("Container/TurnLight").connect("toggled", self, "toggle_light")
	
	background_blur = preload("res://prefabs/2d/BackgroundBlur.tscn").instance()
	background_blur.get_node("Image").texture = $Background.texture
	add_child(background_blur)
	
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


func toggle_light(button_pressed: bool) -> void:
	light_off = button_pressed
	if light_off:
		tween.interpolate_property(scene_light, "color", scene_light.color, Color(0.25, 0.25, 0.25), 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(true)
		
	else:
		tween.interpolate_property(scene_light, "color", scene_light.color, Color.white, 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(false)
	tween.start()

func load_puzzle(puzzle_id : String) -> void:
	GameManager.puzzle_id = int(puzzle_id)
	transition.transition_to_scene("res://scenes/puzzles/StartAnimation.tscn")
