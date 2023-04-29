extends Control

func _ready() -> void:
	$Console.terminal.connect("command_executed", self, "_command_executed")

func _command_executed(command, output) -> void:
	var _op = command.options[0]
