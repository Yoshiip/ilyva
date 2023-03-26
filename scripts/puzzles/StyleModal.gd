extends "res://scripts/ui/Modal.gd"


func _ready() -> void:
	var ColorButton := preload("res://prefabs/puzzles/ColorButton.tscn")
	var _colors := [
		Color("f72585"),
		Color("7209b7"),
		Color("3a0ca3"),
		Color("4361ee"),
		Color("4cc9f0")
	]
	
	for i in _colors:
		var _btn := ColorButton.instance()
		_btn.modulate = i
		_btn.connect("pressed", get_tree().current_scene, "change_background_color", [ i ])
		$Content/Container/Colors.add_child(_btn)
