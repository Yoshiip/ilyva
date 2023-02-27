extends Command

func run(args : Array) -> void:
	if args.size() == 0:
		$Ilynano.window_title = "Ilynano"
		$Ilynano/Text.text = ""
		$Ilynano.popup()
		return
	var _path = terminal.path.right(1)
	var _filename := get_path_filename(args[0])
	
	if contains_illegal_characters(_filename):
		terminal.print_text("Filename contain illegal characters.")
		return
	if _path != "":
		_path += "/"
	_path += args[0]
	print(get_path_without_filename(_path))
	if system.get_node_or_null(get_path_without_filename(_path)) == null:
		terminal.print_text("Path not valid")
		return

	var _file = TerminalFile.new()
	_file.name = _filename
	system.get_node(get_path_without_filename(_path)).add_child(_file)
