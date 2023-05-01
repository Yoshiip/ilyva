extends BasePuzzleHandler

# la solution en une seule ligne :
# chmod 777 menu.txt

var system := System.new([
	SystemElement.new(0, "users.txt", "/", "Thomas:user:6482\nAymeri:user:6482\nNicolas:admin:6482\nroot:root:0108Noé:user:6482\nManon:admin:6482\n", [], "root", "root"),
	SystemElement.new(0, "menu.txt", "/", "1 Pâtes Jambon\n2 Pâtes nature\n", [], "root", "root", "000")
])

func command_executed(command, output) -> void:
	var menu = system.get_element_with_absolute_path(PathObject.new("/menu.txt"))
	if menu is SystemElement:
		if menu.can_write():
			grant_victory()
