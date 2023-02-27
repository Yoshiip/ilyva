extends Command

func run(args : Array) -> void:
	if args.size() > 0:
		terminal.print_text("help of " + args[0] + ": " + get_parent().get_node(args[0]).description)
	else:
		terminal.print_text("[b][color=red]" + terminal.bash_name + "[/color][/b]")
		for command in get_parent().get_children():
			terminal.print_text(command.name + " - " + command.description)
