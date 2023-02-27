extends Command

func run(args : Array) -> void:
#	print(terminal.path.right(1) + args[0])
	
	var _total : Array
	if terminal.path.right(1) != "":
		_total.append_array(terminal.path.right(1).split("/"))
	
	_total.append_array(args[0].split("/"))
	
	printerr(_total)
	var _current_node = system
	for i in _total:
		if i == "..":
			_current_node = _current_node.get_parent()
		else:
			_current_node = _current_node.get_node_or_null(i)
			if _current_node == null:
				terminal.print_text("\"" + i + "\" is not valid")
				return

	terminal.path = str(_current_node.get_path()).right(21)
