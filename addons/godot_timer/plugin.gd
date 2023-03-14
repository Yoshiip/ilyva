tool
extends EditorPlugin

var widget : Control

func _enter_tree() -> void:
	widget = preload("res://addons/godot_timer/Widget.tscn").instance()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, widget)
#	add_control_to_dock(EditorPlugin.DOCK_SLOT_MAX, widget)

	

func _exit_tree() -> void:
#	remove_control_from_docks(widget)
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, widget)
	widget.queue_free()
