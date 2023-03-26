extends Node

signal settings_updated

export var scene_start_dialogue := ""

const APPS := {
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
	"hex": {
		"icon": 2,
#		"reference": preload("res://prefabs/puzzles/modals/Terminal.tscn"),
	},
	"digicode": {
		"icon": 3,
		"reference": preload("res://prefabs/puzzles/modals/Digicode.tscn"),
	},
	"apps": {
		"icon": 4,
		"reference": preload("res://prefabs/puzzles/modals/Apps.tscn"),
	},
	"duck": {
		"icon": 7,
		"reference": preload("res://prefabs/puzzles/modals/Duck.tscn"),
	},
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
	},
	{
		"name": "Pont de Bois",
		"offset": 224,
		"scene": "res://scenes/StPhilibert/Main.tscn",
	},
	{
		"name": "Beaux Arts",
		"offset": 710,
		"scene": "res://scenes/StPhilibert/Main.tscn",
	},
	{
		"name": "Porte des Postes",
		"offset": 875,
		"scene": "res://scenes/StPhilibert/Main.tscn",
	},
	{
		"name": "Saint-Philibert",
		"offset": 1440,
		"scene": "res://scenes/StPhilibert/Main.tscn",
	},
]


var puzzles := {
	0: {
		"portrait": preload("res://images/portraits/jvlivm.png")
	}
}
var puzzle_id := -1


var settings := {
	"3d_quality": 2, # 0 = low, 1 = medium, 2 = high
	"disable_3d": false,
	"fov": 70,
	"sensivity": 10.0
} setget set_settings


var sultans := []
var items := []


func set_settings(value) -> void:
	settings = value
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
	emit_signal("settings_updated")
