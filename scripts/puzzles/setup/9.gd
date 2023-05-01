extends BasePuzzleHandler

# la solution en une seule ligne :
# echo something >target ; echo $(cat target)

var system := System.new([])
var redirection_path = null # PathObject

func command_executed(command, output) -> void:
	var redirection_on_standard_output = command.redirections[1]
	if redirection_on_standard_output != null and redirection_on_standard_output.type == Tokens.WRITING_REDIRECTION:
		redirection_path = (redirection_on_standard_output.target as SystemElement).absolute_path

func interface_changed(content: String) -> void:
	if redirection_path != null:
		var redirected_file = system.get_element_with_absolute_path(redirection_path)
		if redirected_file != null and redirected_file.content == content:
			grant_victory()
