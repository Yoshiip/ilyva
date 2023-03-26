extends "res://scripts/ui/Modal.gd"


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Content/Terminal.terminal.connect("command_executed", self, "_command_executed")

func _command_executed(cmd : Dictionary, err : String) -> void:
	print(cmd, err)
