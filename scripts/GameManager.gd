extends Node


signal settings_updated

onready var extra := false

var scene_start_dialogue := ""

var save_data : SaveData

var timer : Timer

func _ready() -> void:
	randomize()
	extra = OS.get_name() != "HTML5"
	AudioServer.set_bus_volume_db(music_bus, linear2db(settings.music / 100.0))
	AudioServer.set_bus_volume_db(effects_bus, linear2db(settings.effects / 100.0))
	
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "playtime_timer")

func playtime_timer() -> void:

	playtime += 1


func new_game() -> void:
	save_data = SaveData.new()
	apply_data()

const PROPERTIES_TO_SAVE := ["progress", "unlocked_levels", "current_subway_stop", "sultans", "items", "puzzles_solves", "playtime"]

func apply_data() -> void:
	for property in PROPERTIES_TO_SAVE:
		set(property, save_data.get(property))
	

func load_save() -> void:
	save_data = SaveData.new().load_data()
	apply_data()

func save() -> void:
	if save_data != null:
		for property in PROPERTIES_TO_SAVE:
			save_data.set(property, get(property))
		save_data.scene_path = get_tree().current_scene.filename
		save_data.save_data()

#var current_puzzle : Resource

# debug
var current_puzzle := preload("res://resources/puzzles/4.tres")
var context_before_puzzle = null

var progress := {
	"global": 0,
	"saint_philibert": {
		"Thomas": 0,
		"Mathieu": 0,
		"Nano": 0,
		"action_unlocked": false,
		"can_use_subway": false,
		"Louane": 0,
	},
	"beaux_arts": {
		"digicode_unlocked": false,
		"has_card": false,
		"toilets": false,
		"Digicode": 0,
		"Clément": 0,
		"Manon": 0,
		"Chiba": 0,
		"Sultan": 0,
		"Station": 0,
	},
	"pont_de_bois": {
		"Rat": 0,
	},
	"iut": {
		"CDI": 0,
		"Couloir": 0,
		"Station": 0,
		"Bureau": 0,
		"Progress": 0,
		"Bastum": 0,
	},
	"game_finished": false,
}

var sultans := []
var items := []

var playtime := 0

var puzzles_solves := 0

var unlocked_levels := [
	0, 1, 3
]
var current_subway_stop := 3

func unlock_level(level_id : String) -> void:
	if !unlocked_levels.has(level_id):
		unlocked_levels.append(int(level_id))

var settings := {
	"3d_quality": 2, # 0 = low, 1 = medium, 2 = high
	"enable_3d": false,
	"fov": 70,
	"sensivity": 10.0,
	"music": 50,
	"effects": 50,
	"3d_resolution": 75,
	"voices": 50,
} setget set_settings


const ITEMS := {
	"traminus": {
		"name": "Traminus",
		"description": "Vous permet de parler avec les autres.",
		"icon": preload("res://images/items/traminus.png"),
	},
	"subway_card": {
		"name": "Carte bash bash",
		"description": "C'est Clément qui vous l'a donné. Vous permet de voyager en illimité sur le réseau Ilyva!",
		"icon": preload("res://images/items/bashbash.png"),
	},
	"key": {
		"name": "Clé",
		"description": "C'est le rat qui vous l'a donnée.",
		"icon": preload("res://images/items/key.png"),
	},
	"wallet": {
		"name": "Porte monnaie de Mathieu",
		"description": "Espèce de voleur!",
		"icon": preload("res://images/items/wallet.png"),
	},
}


const APPS := {
	"terminal": {
		"icon": 0,
		"reference": preload("res://prefabs/puzzles/modals/Terminal.tscn"),
	},
	"digicode": {
		"icon": 3,
		"reference": preload("res://prefabs/puzzles/modals/Digicode.tscn"),
		"by_default": false,
	},
	"hints": {
		"icon": 1,
		"reference": preload("res://prefabs/puzzles/modals/Hints.tscn"),
	},
	"instructions": {
		"icon": 6,
		"reference": preload("res://prefabs/puzzles/modals/Instructions.tscn"),
	},
	"apps": {
		"icon": 4,
		"reference": preload("res://prefabs/puzzles/modals/Apps.tscn"),
	},
	"help": {
		"icon": 7,
		"reference": preload("res://prefabs/puzzles/modals/Help.tscn"),
	},
	"style": {
		"icon": 5,
		"reference": preload("res://prefabs/puzzles/modals/Style.tscn"),
	},
	"music": {
		"icon": 8,
		"reference": preload("res://prefabs/puzzles/modals/Music.tscn"),
	}
}


const STATIONS := [
	{
		"name": "Cité Scientifique\nPf. Bastvm",
		"offset": 56,
		"scene": "res://scenes/IUT/Station.tscn",
		"line": 1,
	},
	{
		"name": "Pont de Bois",
		"offset": 224,
		"scene": "res://scenes/PontDeBois/Station.tscn",
		"line": 1,
	},
	{
		"name": "République\nBeaux-Arts",
		"offset": 710,
		"scene": "res://scenes/BeauxArts/Station.tscn",
		"line": 1,
	},
#	{
#		"name": "Porte des Postes",
#		"offset": 875,
#		"scene": "res://scenes/StPhilibert/Main.tscn",
#		"line": 2,
#	},
	{
		"name": "Saint-Philibert",
		"offset": 1440,
		"scene": "res://scenes/StPhilibert/Station.tscn",
		"line": 2,
	},
]


func add_to_inventory(item_id : String, callback = "") -> void:
	if !items.has(item_id):
		items.append(item_id)
		play_new_item_animation(item_id, false, callback)




func add_sultan(sultan_id : String) -> void:
	if !sultans.has(sultan_id):
		sultans.append(sultan_id)
		play_new_item_animation(sultan_id, true)
		if sultans.size() == 12:
			GameManager.progress.saint_philibert.Thomas = 3


onready var NewItem := preload("res://prefabs/ui/NewItem.tscn")
onready var DebugMenu := preload("res://prefabs/DebugMenu.tscn")
func play_new_item_animation(item_id : String, is_sultan = false, callback = "") -> void:
	var new_item := NewItem.instance()
	new_item.item_id = item_id
	new_item.is_sultan = is_sultan
	if callback != "":
		new_item.callback = callback
	get_tree().current_scene.add_child(new_item)
	

onready var music_bus := AudioServer.get_bus_index("Music")
onready var effects_bus := AudioServer.get_bus_index("Effects")
onready var voices_bus := AudioServer.get_bus_index("Voices")


func set_settings(value) -> void:
	settings = value
	AudioServer.set_bus_volume_db(music_bus, linear2db(settings.music / 100.0))
	AudioServer.set_bus_volume_db(effects_bus, linear2db(settings.effects / 100.0))
	AudioServer.set_bus_volume_db(voices_bus, linear2db(settings.voices / 100.0))
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
	emit_signal("settings_updated")
	

var debug_menu : CanvasLayer

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("speedhack"):
		if is_instance_valid(debug_menu):
			debug_menu.queue_free()
		else:
			debug_menu = DebugMenu.instance()
			get_tree().current_scene.add_child(debug_menu)
