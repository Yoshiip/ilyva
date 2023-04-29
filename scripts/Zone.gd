extends Node2D

signal story_progress_changed


export var zone_id := "unnamed"
export var zone_name := "Unnamed"
#export(String, "Matin", "Après-Midi", "Soirée") var time
export var start_scene := false
export var music_id := "night"

var in_dialogue = false

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

func _ready() -> void:
	var _camera := preload("res://prefabs/2d/GameCamera.tscn").instance()
	_camera.name = "Camera"
	add_child(_camera)
	
	name = "Root"
	if GameManager.context_before_puzzle != null:
		var _n = get_node(GameManager.context_before_puzzle.path)
		_n.timeline_id = GameManager.progress[zone_id][_n.character_name if _n.character_name != "" else _n.name]
		_n.interact()
		GameManager.context_before_puzzle = null
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_camera.limit_left = -image_size / 2
	_camera.limit_right = image_size / 2
	pause_menu = PauseMenu.instance()
	
	
	add_child(canvas)
	add_child(tooltip)
	add_child(cursor)
	add_child(tween)
	add_child(scene_light)
	
	canvas.add_child(transition)
	canvas.get_node("Container/TurnLight").connect("toggled", self, "toggle_light")
	
	background_blur = preload("res://prefabs/2d/BackgroundBlur.tscn").instance()
	background_blur.get_node("Image").texture = $Background.texture
	add_child(background_blur)
	
	$Canvas/Container.add_child(pause_menu)
	if GameManager.scene_start_dialogue != zone_id && start_scene:
		var new_dialog = Dialogic.start(zone_id + '/' + zone_name)
		GameManager.scene_start_dialogue = zone_id
		add_child(new_dialog)

	$Canvas/Container/ZoneName.text = zone_name
#	$Canvas/Container/Time.text = time

func _physics_process(_delta: float) -> void:
	for arrow in arrows:
		if is_instance_valid(arrow):
			arrow.visible = !in_dialogue
	in_dialogue = false
	for i in get_children():
		if i.get("dialog_node"):
			in_dialogue = true
			pause_menu.can_pause = !in_dialogue
			return
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


var current_dialogue_character : Node2D
var current_dialogue_id := 0

func load_puzzle(puzzle_id : String) -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/" + puzzle_id + ".tres"))
	GameManager.context_before_puzzle = {
		"scene": get_tree().current_scene.filename,
		"path": current_dialogue_character.get_path(),
		"id": current_dialogue_id,
	}
	transition.transition_to_scene("res://scenes/puzzles/StartAnimation.tscn")

func add_story_progress() -> void:
	print("a refaire")
#	GameManager.story_progress += 1
#	emit_signal("story_progress_changed")
#	print(GameManager.story_progress)

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
