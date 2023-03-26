extends "res://scripts/ui/Modal.gd"

func _ready() -> void:
	if puzzle != null:
		$Content/Name.text = puzzle.name
		$Content/Instructions.text = puzzle.description
		$Content/Number.text = str("N°", puzzle.get_puzzle_id())
