extends Command


func run(args : Array) -> void:
	var _text = ""
	for i in system.get_children():
		_text += add(i)
		if i is Folder:
			_text += sub_files(i)
	terminal.print_text(_text)


func add(node) -> String:
	if node is Folder:
		return "[color=green]" + node.name + "[/color]\n"
	return node.name + "\n"
	


func sub_files(node, space = 1) -> String:
	var text = ""
	for i in node.get_children():
		for s in space:
			text += "    "
		text += add(i)
		if i is Folder:
			text += sub_files(i, space + 1)
	return text
