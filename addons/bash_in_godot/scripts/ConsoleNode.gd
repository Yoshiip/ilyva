#warning-ignore-all:return_value_discarded
extends Panel

const INIT_TEXT = "Terminal M100 0.2.2\nLe terminal fait maison [b]simplifié[/b].\nEntrez \"help\" si vous avez besoin d'aide.\n-----------------\n"

export(String) var user_name
export(String) var group_name
export(NodePath) var reference_node
export(String) var ip_address = ""
export(int) var pid = -1
export(int) var max_paragraph_size = -1
export(float) var default_font_size = 14

onready var interface: RichTextLabel = preload("res://addons/bash_in_godot/scenes/Interface.tscn").instance(); # the terminal
onready var prompt: LineEdit = preload("res://addons/bash_in_godot/scenes/Prompt.tscn").instance(); # the input
onready var editor: WindowDialog = preload("res://addons/bash_in_godot/scenes/NanoEditor.tscn").instance(); # "nano"

var terminal: Terminal
var dns_config := DNS.new([])
var history := [] # array of strings containing all previous entered commands
var history_index := 0 # the position in the history. By default, it will have the size of the history array as value

func set_system(system_reference: System) -> void:
	terminal.system = system_reference
	terminal.PWD = PathObject.new("/") # just in case the user was already somewhere else when this function was called.

func _ready():
	if pid < 0:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		pid = rng.randi_range(100, 10000)
	yield(get_node("../../"), "ready")
	var node := get_node_or_null(reference_node)
	var system := System.new([])
	var allowed_commands := []
	var forbidden_commands := []
	var initial_context = null
	if node != null:
		if "system" in node:
			system = node.system
		if "dns" in node:
			dns_config = node.dns
		# if an ip address is defined here using the export, the one from the node is ignored
		if "ip_address" in node and ip_address.empty():
			ip_address = node.ip_address
		# if a max paragraph size is defined using the export variable, it will override the one defined in the node.
		# If none are given, nor valid, then the default one from the Terminal scene is used.
		if "max_paragraph_size" in node and max_paragraph_size == -1:
			max_paragraph_size = node.max_paragraph_size
		if "allowed_commands" in node:
			allowed_commands = node.allowed_commands
		if "forbidden_commands" in node:
			forbidden_commands = node.forbidden_commands
		if "runtime" in node:
			initial_context = node.runtime
	terminal = Terminal.new(pid, system, editor)
	terminal.set_dns(dns_config)
	if max_paragraph_size > 0:
		terminal.set_custom_text_width(max_paragraph_size)
	if not ip_address.empty():
		terminal.set_ip_address(ip_address)
	if not allowed_commands.empty():
		terminal.set_allowed_commands(allowed_commands)
	if not forbidden_commands.empty():
		terminal.forbid_commands(forbidden_commands)
	if initial_context != null:
		terminal.runtime[0] = initial_context
	add_child(interface)
	add_child(prompt)
	add_child(editor)
	theme = preload("res://addons/bash_in_godot/resources/terminal.tres")
	prompt.connect("text_entered", self, "_on_command_entered")
	if user_name != null:
		terminal.user_name = user_name
	if group_name != null:
		terminal.group_name = group_name
	interface.append_bbcode(INIT_TEXT)
	set_font_size(default_font_size)

	get_tree().current_scene.puzzle_handler.terminal_created(self)

func _process(_delta):
	# Before, when pressing "ui_up" or "ui_down",
	# all consoles received the order,
	# and acted accordingly.
	# We need to know if the current prompt has the focus, but the behaviour is kinda weird,
	# because the focus is lost before the _process function gets executed,
	# so we can't test if the prompt has the focus, because it's already gone.
	# For some reason, this behaviour only applies on "ui_up". 
	if Input.is_action_just_pressed("ui_up"):
		# When the focus is on Prompt, and then "ui_up" is pressed,
		# and before this function gets executed,
		# the interface, for some reason, receives the focus.
		# Looks like a RichTextLabel can receive focus, whereas it should not... cause it's readonly...
		if not (interface.has_focus() or prompt.has_focus()):
			return
		prompt.grab_focus()
		if history_index > 0:
			history_index -= 1
			prompt.text = history[clamp(history_index, 0, history.size() - 1)]
			prompt.set_cursor_position(prompt.text.length())
	if Input.is_action_just_pressed("ui_down"):
		if not prompt.has_focus():
			return
		if history_index < history.size() - 1:
			history_index += 1
			prompt.text = history[history_index]
			prompt.grab_focus()
			prompt.set_cursor_position(prompt.text.length())
		elif prompt.text != "":
			history_index += 1
			prompt.clear()
			prompt.grab_focus()
	if Input.is_action_just_pressed("autocompletion"):
		# we don't want autocompletion when the user is editing a file using nano
		if terminal.edited_file != null:
			return
		prompt.grab_focus()
		if not prompt.text.empty():
			var possibilites := [] # array of string containing the possible names to autocomplete with
			var word_position := prompt.text.find_last(" ")
			if word_position == -1:
				word_position = 0
			var full_path := prompt.text.right(word_position).strip_edges()
			var base_dir := full_path.left(full_path.find("/")) + "/" if full_path.find("/") != -1 else ""
			var word_to_complete := ""
			if full_path.find("/") != -1:
				word_to_complete = full_path.right(full_path.find("/") + 1)
			else:
				word_to_complete = full_path
			var element = terminal.get_parent_element_from(PathObject.new(full_path)) if not word_to_complete.empty() else terminal.get_file_element_at(PathObject.new(full_path))
			# the user keeps writing down a path that doesn't even exist:
			if element == null:
				return
			if not element.can_read():
				return # cannot autocomplete with the files contained in a folder we can't read from
			for child in element.children:
				if child.filename.begins_with(word_to_complete):
					possibilites.append(child.filename)
			if possibilites.size() > 0:
				if possibilites.size() == 1:
					prompt.text = (prompt.text.substr(0, word_position) + " " + base_dir + possibilites[0]).strip_edges()
				else:
					var pos = word_to_complete.length()
					var word = possibilites[0].substr(0, pos)
					for i in range(1, possibilites[0].length()):
						word = possibilites[0].substr(0, pos + i)
						var found_difference = false
						for y in range(1, possibilites.size()):
							if not possibilites[y].begins_with(word):
								found_difference = true
								break
						if found_difference:
							break
					# if we found a difference, it also means that we went one character too far,
					# hence the substring of `word`
					word = word.substr(0, word.length() - 1)
					if word == word_to_complete:
						return # useless to change the text
					prompt.text = (prompt.text.substr(0, word_position) + " " + base_dir + word).strip_edges()
				prompt.grab_focus()
				prompt.set_cursor_position(prompt.text.length())

func _on_command_entered(new_text: String):
	if new_text.strip_edges().empty():
		return
	prompt.clear()
	history.append(new_text)
	history_index = history.size()
	if not terminal.m99.started:
		_print_command(new_text)
	var result := terminal.execute(new_text, interface)
	# It is possible that there are not outputs.
	# It happens when the command is just a variable declaration for example.
	# Note that the `clear` command will produce an output anyway, but with an empty text.
	for output in result.outputs:
		if output.error != null:
			_print_error(output.error)
		else:
			if output.interface_cleared:
				interface.text = ""
			interface.append_bbcode(output.text)

func _print_command(command: String):
	interface.append_bbcode("$ " +  command + "\n")

func _print_error(description: String):
	interface.append_bbcode("[color=red]" + description + "[/color]\n")

func set_font_size(size: int) -> void:
	interface.get("custom_fonts/normal_font").size = size
	interface.get("custom_fonts/bold_font").size = size
