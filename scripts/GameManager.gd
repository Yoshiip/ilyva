extends Node

signal settings_updated

var scene_start_dialogue := ""

#var current_puzzle : Resource

# debug
var current_puzzle := preload("res://resources/puzzles/3.tres")
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
		"Digicode": 0,
		"Clément": 0,
		"Manon": 0,
		"Chiba": 0,
		"Sultan": 0,
	},
	"pont_de_bois": {
		"Rat": 0,
	},
	"iut": {
		"CDI": 0,
		"Bureau": 0,
	}
}

var unlocked_levels := [
	3, 0
]

func unlock_level(level_id : String) -> void:
	unlocked_levels.append(int(level_id))

var current_subway_stop := 3



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
		"description": "C'est le rat qui vous l'a donné.",
		"icon": preload("res://images/items/traminus.png"),
	},
	"wallet": {
		"name": "Porte monnaie de Mathieu",
		"description": "Espèce de voleur!",
		"icon": preload("res://images/items/traminus.png"),
	},
}


var one_time_interacts := []


func _ready() -> void:
	if OS.get_name() == "HTML5":
		settings.enable_3d = false
	else:
		settings.enable_3d = false


const APPS := {
	"help": {
		"icon": 7,
		"reference": preload("res://prefabs/puzzles/modals/Help.tscn"),
	},
	"terminal": {
		"icon": 0,
		"reference": preload("res://prefabs/puzzles/modals/Terminal.tscn"),
	},
	"hints": {
		"icon": 1,
		"reference": preload("res://prefabs/puzzles/modals/Hints.tscn"),
	},
	"instructions": {
		"icon": 6,
		"reference": preload("res://prefabs/puzzles/modals/Instructions.tscn"),
	},
#	"hex": {
#		"icon": 2,
#		"reference": preload("res://prefabs/puzzles/modals/Terminal.tscn"),
#	},
	"digicode": {
		"icon": 3,
		"reference": preload("res://prefabs/puzzles/modals/Digicode.tscn"),
		"by_default": false,
	},
	"apps": {
		"icon": 4,
		"reference": preload("res://prefabs/puzzles/modals/Apps.tscn"),
	},
#	"duck": {
#		"icon": 7,
#		"reference": preload("res://prefabs/puzzles/modals/Duck.tscn"),
#	},
	"style": {
		"icon": 5,
		"reference": preload("res://prefabs/puzzles/modals/Style.tscn"),
	},
}


const STATIONS := [
	{
		"name": "Cité Scientifique\nPf. Bastvm",
		"offset": 56,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 1,
	},
	{
		"name": "Pont de Bois",
		"offset": 224,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 1,
	},
	{
		"name": "Beaux Arts",
		"offset": 710,
		"scene": "res://scenes/StPhilibert/Main.tscn",
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
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 2,
	},
]



var settings := {
	"3d_quality": 2, # 0 = low, 1 = medium, 2 = high
	"enable_3d": false,
	"fov": 70,
	"sensivity": 10.0
} setget set_settings


var sultans := []
var items := []


func add_to_inventory(item_id : String, _callback = "") -> void:
	if !items.has(item_id):
		items.append(item_id)
#		play_new_item_animation(item_id, false, callback)




func add_sultan(sultan_id : String) -> void:
	if !sultans.has(sultan_id):
		sultans.append(sultan_id)
		play_new_item_animation(sultan_id, true)
		if sultans.size() == 12:
			GameManager.progress.saint_philibert.Thomas = 3


onready var NewItem := preload("res://prefabs/ui/NewItem.tscn")

func play_new_item_animation(item_id : String, is_sultan = false, callback = "") -> void:
	var new_item := NewItem.instance()
	new_item.item_id = item_id
	new_item.is_sultan = is_sultan
	if callback != "":
		new_item.callback = callback
	get_tree().current_scene.get_node("Canvas/Container").add_child(new_item)
	

func set_settings(value) -> void:
	settings = value
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
	emit_signal("settings_updated")

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
