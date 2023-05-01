extends "res://scripts/ui/Modal.gd"



func _ready() -> void:
	if get_tree().current_scene.get_node_or_null("PuzzleHandler") != null:
		$Content/Console.reference_node = $Content/Console.get_path_to(get_tree().current_scene.get_node("PuzzleHandler"))
