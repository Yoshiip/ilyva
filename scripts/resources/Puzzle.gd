extends Resource

class_name Puzzle

export var name = "Unnamed Puzzle"
export(String, MULTILINE) var description = ""
export var given_by = ""
export var hints = [
	"Hint 1",
	"Hint 2",
	"Hint 3",
]

func get_puzzle_id():
	return resource_path.get_file().trim_suffix('.tres')
