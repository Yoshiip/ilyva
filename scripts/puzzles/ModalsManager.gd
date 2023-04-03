extends Control


func _ready() -> void:
	open_modal("apps", Vector2(256, get_viewport().size.y - 180))
	open_modal("instructions", Vector2(get_viewport().size.x / 2.0, 128), true)
	

func open_modal(modal_name : String, position = null, pinned = false) -> void:
	if !GameManager.APPS.get(modal_name).get("reference"):
		print("wip")
		return
	var modal = GameManager.APPS.get(modal_name).get("reference").instance()
	modal.puzzle = get_tree().current_scene.puzzle
	modal.app_id = modal_name
	if position == null:
		modal.rect_position = Vector2(rand_range(0, get_viewport().size.x - modal.rect_size.x), rand_range(0, get_viewport().size.y - modal.rect_size.y))
	else:
		modal.rect_position = Vector2(position.x - modal.rect_size.x / 2.0, position.y - modal.rect_size.y / 2.0)
	modal.pinned = pinned
	print(modal.pinned)
	add_child(modal)
	for i in get_children():
		if i.pinned:
			move_child(i, get_child_count())

func move_modal(modal : Panel) -> void:
	move_child(modal, get_child_count())
	for i in get_children():
		if i.pinned:
			move_child(i, get_child_count())
