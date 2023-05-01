extends "res://scripts/ui/Modal.gd"

func _ready() -> void:
	_update_text()
	get_tree().connect("screen_resized", self, "_update_text")

func _update_text() -> void:
	if puzzle != null:
		$Content/Name.text = puzzle.name
		$Content/Instructions.text = puzzle.description
		$Content/Number.text = str("Énigme n°", puzzle.get_puzzle_id())
