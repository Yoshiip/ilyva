extends "res://scripts/ui/Modal.gd"


func _ready() -> void:
	var DigicodeButton := preload("res://prefabs/puzzles/DigicodeButton.tscn")
	for i in "0123456789abcdef-=":
		
		var button := DigicodeButton.instance()
		if i in "0123456798abcdef":
			button.text = i
		else:
			match i:
				"-":
					button.modulate = Color.red
					button.text = "EFF"
				"=":
					button.modulate = Color.green
					button.text = "OK"
		$Content/Grid.add_child(button)
		if button.connect("pressed", self, "_pressed", [ button.text ]) != OK:
			print("Error signal")


func _pressed(text : String) -> void:
	if text == "OK":
		if $Content/Screen.text == "451acf":
			get_tree().current_scene.puzzle_ended(false)
			$Content/Screen.text = "CORRECT"
		else:
			$Content/Screen.text = "INCORRECT"
	elif text == "EFF":
		if $Content/Screen.text.length() != 0:
			$Content/Screen.text = $Content/Screen.text.substr(0, $Content/Screen.text.length() - 1)
	elif $Content/Screen.text.length() < 6 || $Content/Screen.text == "INCORRECT": # basic number
		if $Content/Screen.text == "INCORRECT":
			$Content/Screen.text = ""
		$Content/Screen.text += text
		
