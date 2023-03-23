extends "res://scripts/ui/Modal.gd"


func _ready() -> void:
	var DigicodeButton := preload("res://prefabs/puzzles/DigicodeButton.tscn")
	for i in 12:
		var button := DigicodeButton.instance()
		if i < 9:
			button.text = str(i + 1)
		else:
			match i:
				9:
					button.text = "EFF"
				10:
					button.text = "0"
				11:
					button.text = "OK"
		$Content/Grid.add_child(button)
		button.connect("pressed", self, "_pressed", [ button.text ])


func _pressed(text : String) -> void:
	if text == "OK":
		$Content/Screen.text = ""
	elif text == "EFF":
		if $Content/Screen.text.length() != 0:
			$Content/Screen.text = $Content/Screen.text.substr(0, $Content/Screen.text.length() - 1)
	elif $Content/Screen.text.length() < 6: # basic number
		$Content/Screen.text += text
		
