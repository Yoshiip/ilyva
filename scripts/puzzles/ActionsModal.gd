extends "res://scripts/ui/Modal.gd"



func _on_Terminal_pressed() -> void:
	get_parent().open_modal("terminal")


func _on_Hints_pressed() -> void:
	get_parent().open_modal("hints")

