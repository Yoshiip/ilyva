extends Control

const bash_name = "ILYVA bash, version 1.0"

var path := "/"


func print_text(text : String, new_line = true) -> void:
	$Text.bbcode_text += text + ("\n" if new_line else "")
	

func clear_text() -> void:
	$Text.bbcode_text = ""

var history = []
var history_value = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") && history_value > 0:
		history_value -= 1
		$Input.text = history[clamp(history_value, 0, history.size() - 1)]
	if Input.is_action_just_pressed("ui_down"):
		if history_value < history.size() - 1:
			history_value += 1
			$Input.text = history[history_value]
		elif $Input.text != "":
			history_value += 1
			$Input.text = ""

func _on_Input_text_entered(new_text: String) -> void:
#	add_text("$" + new_text)
	if new_text == "":
		return
	var text = new_text.split(" ", false)
	var command_found := false
	history.append(new_text)
	history_value = history.size()
	$Input.text = ""
	for command in $Commands.get_children():
		if command.name == text[0]:
			command_found = true
			if text.size() - 1 >= command.min_args:
				text.remove(0)
				command.run(text)
			else:
				print_text(str("Command \"", text[0], "\" need ", command.min_args, " argument(s), and you specified ", text.size() - 1, "."))
			return
	if !command_found:
		print_text("Command \"" + new_text + "\" not found, try \"help\" to show a list of commands avaible.")
