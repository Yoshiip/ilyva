extends Node

signal settings_updated

export var scene_start_dialogue := ""

const APPS := {
	"terminal": {
		"icon": 0,
	},
	"hints": {
		"icon": 1,
	},
	"hex": {
		"icon": 2,
	},
	"digicode": {
		"icon": 3,
	},
	"apps": {
		"icon": 4,
	},
}

var puzzles := {
	0: {
		"portrait": preload("res://images/portraits/jvlivm.png")
	}
}
var puzzle_id := -1


var settings := {
	"3d_quality": 1, # 0 = low, 1 = medium, 2 = high
	"disable_3d": false,
	"fov": 70,
	"sensivity": 10.0
} setget set_settings


var sultans := []
var items := []


func set_settings(value) -> void:
	settings = value
	print("tt")
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
	emit_signal("settings_updated", value)
