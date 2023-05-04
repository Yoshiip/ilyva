extends Node2D

const LOCATIONS := {
	"Entrance": "Entrée",
	"Toilets": "Salle de bain",
	"Corridor": "Couloir",
	"Office": "Bureau",
}


export var zone_id := "unnamed"
export var zone_name := "Unnamed"
#export(String, "Matin", "Après-Midi", "Soirée") var time
#export var start_scene := false
export var music_id := "night"

var dialogue_canvas : CanvasLayer = null

export var start_dialogue := false
export var max_dialogue_progress := -1

onready var image_size : int = $Background.texture.get_width()

onready var PauseMenu := preload("res://prefabs/PauseMenu.tscn")
var pause_menu

onready var tooltip := preload("res://prefabs/Tooltip.tscn").instance()
onready var transition := preload("res://prefabs/Transition.tscn").instance()
onready var cursor := preload("res://prefabs/Cursor.tscn").instance()
onready var canvas := preload("res://prefabs/2d/GameCanvas.tscn").instance()



var background_blur : Sprite

onready var scene_light := CanvasModulate.new()
onready var tween := Tween.new()

onready var arrows := get_tree().get_nodes_in_group("Arrow")
onready var characters := get_tree().get_nodes_in_group("Character")

func _ready() -> void:
	var _camera := preload("res://prefabs/2d/GameCamera.tscn").instance()
	_camera.name = "Camera"
	add_child(_camera)
	
	name = "Root"
	if GameManager.context_before_puzzle != null:
		if GameManager.context_before_puzzle.get("path"):
			var _n = get_node(GameManager.context_before_puzzle.path)
			_n.timeline_id = GameManager.progress[zone_id][_n.character_name if _n.character_name != "" else _n.name]
			_n.interact()
		GameManager.context_before_puzzle = null
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_camera.limit_left = -float(image_size) / 2.0
	_camera.limit_right = float(image_size) / 2.0
	pause_menu = PauseMenu.instance()
	
	
	add_child(canvas)
	add_child(tooltip)
	add_child(cursor)
	add_child(tween)
	add_child(scene_light)
	
	add_child(transition)
	if canvas.get_node("Container/TurnLight").connect("toggled", self, "toggle_light") != OK:
		print("error connecting")
	
	background_blur = preload("res://prefabs/2d/BackgroundBlur.tscn").instance()
	background_blur.get_node("Image").texture = $Background.texture
	add_child(background_blur)
	
	add_child(pause_menu)
	if start_dialogue && GameManager.progress[zone_id][zone_name] < max_dialogue_progress:
		create_dialogue(str(zone_id, '/', zone_name, '/', GameManager.progress[zone_id][zone_name]))

	$Canvas/Container/ZoneName.text = zone_name
	
	MusicManager.start_music(music_id)
	GameManager.save()

var in_dialogue := false

func _physics_process(_delta: float) -> void:
	in_dialogue = is_instance_valid(dialogue_canvas)
	for arrow in arrows:
		if is_instance_valid(arrow):
			arrow.visible = !in_dialogue
	for character in characters:
		if is_instance_valid(character) && character.can_interact:
			character.visible = !in_dialogue
	pause_menu.can_pause = !in_dialogue

#func play_music() -> void:


var light_off := false


func toggle_light(button_pressed: bool) -> void:
	light_off = button_pressed
	if light_off:
		var _temp := tween.interpolate_property(scene_light, "color", scene_light.color, Color(0.25, 0.25, 0.25), 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(true)
		
	else:
		var _temp := tween.interpolate_property(scene_light, "color", scene_light.color, Color.white, 0.5)
		for i in get_tree().get_nodes_in_group("Interaction"):
			if i.has_method("turn_light"):
				i.turn_light(false)
	var _temp := tween.start()


var current_dialogue_character : Node2D
var current_dialogue_id := 0

func load_puzzle(puzzle_id : String) -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/" + puzzle_id + ".tres"))
	GameManager.context_before_puzzle = {
		"scene": get_tree().current_scene.filename
	}
	if is_instance_valid(current_dialogue_character): # for scene that automaticly start dialogue
		GameManager.context_before_puzzle["path"] = current_dialogue_character.get_path()
		GameManager.context_before_puzzle["id"] = current_dialogue_id
		

	transition.transition_to_scene("res://scenes/puzzles/StartAnimation.tscn")

func increment_progress(character_id = "", c_zone_id = "") -> void:
	if character_id != "" && c_zone_id != "":
		GameManager.progress[c_zone_id][character_id] += 1
		if get_node_or_null(character_id):
			character_id.progress_changed()
	elif character_id != "":
		GameManager.progress[zone_id][character_id] += 1
		if get_node_or_null(character_id):
			get_node(character_id).progress_changed()
	else:
		GameManager.progress[zone_id][current_dialogue_character.character_name] += 1
		current_dialogue_character.progress_changed()

func story_condition(condition : String, value = "true", zone = zone_id) -> void:
	GameManager.progress[zone][condition] = bool(value)

func change_scene(scene_name : String) -> void:
	transition.transition_to_scene("res://scenes/" + scene_name + ".tscn")

func create_dialogue(id : String) -> void:
	dialogue_canvas = Dialogic.start(id)
	dialogue_canvas.name = "Dialogue"
	add_child(dialogue_canvas)
