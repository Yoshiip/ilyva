extends "res://scripts/ui/Modal.gd"



func _ready() -> void:
	
#	var console := Panel.new()
#	console.script = load("res://addons/bash_in_godot/scripts/ConsoleNode.gd")
#	console.name = "Console"
#	console.rect_min_size = Vector2(100, 100)
#	console.user_name = "user"
#	console.group_name = "user"
	if get_tree().current_scene.get_node_or_null("PuzzleHandler") != null:
		$Content/Console.reference_node = $Content/Console.get_path_to(get_tree().current_scene.get_node("PuzzleHandler"))
#	$Content.add_child(console)
#	get_node("Content/Console/Prompt").grab_focus()
	

#	var system := System.new([
#		SystemElement.new(0, "file.txt", "/", "", [], user_name, group_name),
#		SystemElement.new(1, "folder", "/", "", [
#			SystemElement.new(0, "answer_to_life.txt", "/folder", "42", [], user_name, group_name),
#			SystemElement.new(0, ".secret", "/folder", "ratio", [], user_name, group_name),
#		], user_name, group_name),
#	])
