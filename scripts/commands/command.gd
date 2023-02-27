extends Node


export var min_args := 0
export(String) var description = "Print the command"

onready var terminal := get_parent().get_parent()
onready var system := get_parent().get_parent().get_node("System")

class_name Command



# warning-ignore:unused_argument
func run(args : Array) -> void:
	pass


static func get_path_without_filename(full_path : String) -> String:
	var _path = ""
#	for i in full_path.rsplit('/', true, 1)[0]:
#		_path += "/" + i
	return full_path.rsplit('/', true, 1)[0]


static func get_path_filename(full_path : String) -> String:
	return full_path[0].split("/")[full_path[0].split("/").size() - 1]


static func contains_illegal_characters(text : String) -> bool:
	for i in text:
		if i in ['.', ':', '@', '/', '"', '%']:
			return true
	return false
