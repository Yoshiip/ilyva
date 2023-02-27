extends Command


func run(args : Array) -> void:
	var _path = terminal.path.right(1)
	if _path != "":
		_path += "/"
	_path += args[0]
	if system.get_node_or_null(_path) == null:
		terminal.print_text("File \"" + args[0] + "\" not found")
		return
	if system.get_node_or_null(_path).content == "":
		terminal.print_text("[color=gray]fichier vide...[/color]")
	
	else:
		terminal.print_text(system.get_node_or_null(_path).content)
