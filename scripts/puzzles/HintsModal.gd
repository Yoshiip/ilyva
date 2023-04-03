extends "res://scripts/ui/Modal.gd"



func _ready() -> void:
	$"Content/Tabs/Indice 1/Text".text = puzzle.hints[0]
	$"Content/Tabs/Indice 2/Text".text = puzzle.hints[1]
	$"Content/Tabs/Indice 3/Text".text = puzzle.hints[2]

func _on_SkipPuzzle_pressed() -> void:
	get_tree().current_scene.skip()
