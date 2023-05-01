extends "res://scripts/ui/Modal.gd"



onready var StartAppButton := preload("res://prefabs/puzzles/StartAppButton.tscn")

func _ready() -> void:
	for i in GameManager.APPS.keys():
		if GameManager.APPS[i].get("by_default", true) || puzzle.additional_apps.has(i):
			var button = StartAppButton.instance()
			button.get_node("Icon").texture = button.get_node("Icon").texture.duplicate()
			button.get_node("Icon").texture.region.position.y = GameManager.APPS[i].icon * 16.0
			button.get_node("Label").text = i + ".sh"
			button.connect("pressed", self, "_start_app", [ i ])
			$Content/Scroll/Grid.add_child(button)
	if connect("resized", self, "_resized") != OK:
		printerr("Error")
	_resized()

func _start_app(app_name : String) -> void:
	get_parent().open_modal(app_name)

func _resized() -> void:
	$Content/Scroll/Grid.columns = floor(max(rect_size.x, 178) / 178)
	$Content/Scroll/Grid.rect_size = $Content/Scroll.rect_size
