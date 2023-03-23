extends "res://scripts/ui/Modal.gd"



onready var StartAppButton := preload("res://prefabs/puzzles/StartAppButton.tscn")

func _ready() -> void:
	for i in GameManager.APPS.keys():
		var button = StartAppButton.instance()
		button.get_node("Icon").texture = button.get_node("Icon").texture.duplicate()
		button.get_node("Icon").texture.region.position.y = GameManager.APPS[i].icon * 16.0
		button.get_node("Label").text = i + ".sh"
		button.connect("pressed", self, "_start_app", [ i ])
		$Content/GridContainer.add_child(button)

func _start_app(app_name : String) -> void:
	get_parent().open_modal(app_name)
