extends TextureRect

onready var tooltip: Panel = $"../../Tooltip"

export var item_name := "Carte du flop"
export var item_description := "ratio + flop"

func _ready() -> void:
	if connect("mouse_entered", self, "_mouse_entered") != OK:
		printerr("Error")
	if connect("mouse_exited", self, "_mouse_exited") != OK:
		printerr("Error")

func _mouse_entered() -> void:
	tooltip.hovered(self)

func _mouse_exited() -> void:
	tooltip.unhovered(self)
