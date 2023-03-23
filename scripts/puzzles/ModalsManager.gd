extends Control

const MODALS := {
	"terminal": preload("res://prefabs/puzzles/TerminalModal.tscn"),
	"hints": preload("res://prefabs/puzzles/HintModal.tscn"),
	"digicode": preload("res://prefabs/puzzles/DigicodeModal.tscn"),
}


func open_modal(modal_name : String) -> void:
	if !MODALS.has(modal_name):
		print("wip")
		return
	var modal = MODALS[modal_name].instance()
	modal.app_id = modal_name
	modal.rect_position = Vector2(rand_range(0, get_viewport().size.x - modal.rect_size.x), rand_range(0, get_viewport().size.y - modal.rect_size.y))
	add_child(modal)
	for i in get_children():
		if i.pinned:
			move_child(i, get_child_count())

func move_modal(modal : Panel) -> void:
	move_child(modal, get_child_count())
	for i in get_children():
		if i.pinned:
			move_child(i, get_child_count())
