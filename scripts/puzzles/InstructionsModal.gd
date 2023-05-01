extends "res://scripts/ui/Modal.gd"

func _ready() -> void:
	if puzzle != null:
		$Content/Name.text = puzzle.name
		$Content/Instructions.bbcode_text = puzzle.description
		$Content/Number.text = str("Énigme n°", puzzle.get_puzzle_id())
