extends "res://scripts/ui/Modal.gd"


func _ready() -> void:
	get_node("Content/Console/Prompt").grab_focus()
	$Content/Console.terminal.connect("command_executed", self, "_command_executed")

func _command_executed(_command, _output) -> void:
	var _answer = SystemElement.new(1, "/", "", "", [], "root", "root")
	_answer.children = [
		SystemElement.new(1, "translator", "/", "", [
			SystemElement.new(1, "modules", "/translator", "", [
				SystemElement.new(0, "mod1.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "mod2.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "lang4.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "mod3.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "mod4.bin", "/translator/modules", "", [], "root", "root"),

			], "root", "root"),
			SystemElement.new(1, "langages", "/translator", "", [
				SystemElement.new(0, "satel1.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "lang1.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "lang_2.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "lang3.bin", "/translator/langages", "", [], "root", "root"),
			], "root", "root"),
			SystemElement.new(1, "satellite", "/translator", "", [
				SystemElement.new(0, "satel2.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "satel3.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "satel4.bin", "/translator/satellite", "", [], "root", "root"),

			], "root", "root"),
		], "root", "root")
	]
	print($Content/Console.terminal.system_tree.equals(_answer))

#	var system := System.new([
#		SystemElement.new(0, "file.txt", "/", "", [], user_name, group_name),
#		SystemElement.new(1, "folder", "/", "", [
#			SystemElement.new(0, "answer_to_life.txt", "/folder", "42", [], user_name, group_name),
#			SystemElement.new(0, ".secret", "/folder", "ratio", [], user_name, group_name),
#		], user_name, group_name),
#	])
