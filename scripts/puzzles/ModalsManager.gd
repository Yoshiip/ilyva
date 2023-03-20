extends Control

const MODALS := {
	"terminal": preload("res://prefabs/puzzles/TerminalModal.tscn"),
	"hints": preload("res://prefabs/puzzles/HintModal.tscn"),
}

func open_modal(modal_name : String) -> void:
	var modal = MODALS[modal_name].instance()
	modal.rect_position = Vector2(rand_range(0, get_viewport().size.x - modal.rect_size.x), rand_range(0, get_viewport().size.y - modal.rect_size.y))
	add_child(modal)
