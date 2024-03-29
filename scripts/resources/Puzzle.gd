extends Resource

class_name Puzzle

export(StreamTexture) var portrait
export var name = "Unnamed Puzzle"
export var start_phrase : String = "... vous lance une énigme!"

export(String, MULTILINE) var description = ""
export var given_by = ""
export var hints : PoolStringArray = [
	"Hint 1",
	"Hint 2",
	"Hint 3",
]

export var hints_action : PoolStringArray = [
	"",
	"",
	"",
]

export var additional_apps : PoolStringArray = []

func get_puzzle_id():
	return resource_path.get_file().trim_suffix('.tres')
