extends Command

func run(args : Array) -> void:
	var _path = system
	if terminal.path.right(1) != "":
		_path = system.get_node(terminal.path.right(1))
	print(_path.get_children())
	for file in _path.get_children():
		if file is Folder:
			terminal.print_text(str("[color=green]", file.name, "[/color]"))
	for file in _path.get_children():
		if !(file is Folder):
			terminal.print_text(str(file.name))
