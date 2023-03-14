extends Node

export var scene_start_dialogue := ""


var settings := {
	"3d_quality": 1, # 0 = low, 1 = medium, 2 = high
	"disable_3d": false,
} setget set_settings


var sultans := []
var items := []


func set_settings(value) -> void:
	settings = value
	if get_tree().current_scene.has_method("settings_updated"):
		get_tree().current_scene.call("settings_updated")
