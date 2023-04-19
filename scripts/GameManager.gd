extends Node

signal settings_updated

var scene_start_dialogue := ""

#var current_puzzle : Resource

# debug
var current_puzzle := preload("res://resources/puzzles/1.tres")
var context_before_puzzle = null

var progress := {
	"global": 0,
	"saint_philibert": {
		"Thomas": 0,
		"Mathieu": 0,
		"Nano": 0,
		"action_unlocked": false,
	},
}




const ITEMS := {
	"traminus": {
		"name": "Traminus",
		"description": "Vous permet de parler avec les autres.",
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
#	"digicode": {
#		"icon": 3,
#		"reference": preload("res://prefabs/puzzles/modals/Digicode.tscn"),
#	},
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
		"map_progress": 99,
	},
	{
		"name": "Pont de Bois",
		"offset": 224,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 1,
		"map_progress": 99,
	},
	{
		"name": "Beaux Arts",
		"offset": 710,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 1,
		"map_progress": 2,
	},
	{
		"name": "Porte des Postes",
		"offset": 875,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 2,
		"map_progress": 1,
	},
	{
		"name": "Saint-Philibert",
		"offset": 1440,
		"scene": "res://scenes/StPhilibert/Main.tscn",
		"line": 2,
		"map_progress": 0,
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


func add_to_inventory(item_id : String) -> void:
	if !items.has(item_id):
		items.append(item_id)
		play_new_item_animation(item_id, false)

func add_sultan(sultan_id : String) -> void:
	if !sultans.has(sultan_id):
		sultans.append(sultan_id)
		play_new_item_animation(sultan_id, true)


onready var NewItem := preload("res://prefabs/ui/NewItem.tscn")

func play_new_item_animation(item_id : String, is_sultan = false) -> void:
	var new_item := NewItem.instance()
	new_item.item_id = item_id
	new_item.is_sultan = is_sultan
	get_tree().current_scene.get_node("Canvas/Container").add_child(new_item)
	

func set_settings(value) -> void:
	settings = value
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
	emit_signal("settings_updated")

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
