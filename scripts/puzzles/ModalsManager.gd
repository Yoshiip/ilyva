extends Control


func _ready() -> void:
	open_modal("apps")

func open_modal(modal_name : String) -> void:
	if !GameManager.APPS.get(modal_name).get("reference"):
		print("wip")
		return
	var modal = GameManager.APPS.get(modal_name).get("reference").instance()
	modal.puzzle = get_tree().current_scene.puzzle
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
