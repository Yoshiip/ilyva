extends Command

func run(args : Array) -> void:
	if args.size() == 0:
		$Ilynano.window_title = "Ilynano"
		$Ilynano/Text.text = ""
		$Ilynano.popup()
		return
	var _path = terminal.path.right(1)
	var _filename = args[0].split("/")[args[0].split("/").size() - 1]
	if _path != "":
		_path += "/"
	_path += args[0]
	if system.get_node_or_null(_path) == null:
		terminal.print_text("ILYNANO > Can't open (File \"" + _filename + "\" not found)")
		return
	$Ilynano.window_title = _filename + " - Ilynano"
	$Ilynano/Text.text = system.get_node(_path).content
	$Ilynano.popup()
