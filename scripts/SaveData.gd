class_name SaveData
extends Resource

const SAVE_GAME_BASE_PATH := "user://save"


export var scene_path := ""
export var playtime := 0

export var progress := {
	"global": 0,
	"saint_philibert": {
		"Thomas": 0,
		"Mathieu": 0,
		"Nano": 0,
		"action_unlocked": false,
		"can_use_subway": false,
		"Louane": 0,
	},
	"beaux_arts": {
		"digicode_unlocked": false,
		"has_card": false,
		"toilets": false,
		"Digicode": 0,
		"Clément": 0,
		"Manon": 0,
		"Chiba": 0,
		"Sultan": 0,
		"Station": 0,
	},
	"pont_de_bois": {
		"Rat": 0,
	},
	"iut": {
		"CDI": 0,
		"Couloir": 0,
		"Station": 0,
		"Bureau": 0,
		"Progress": 0,
		"Bastum": 0,
	},
	"game_finished": false,
}
export var sultans := []
export var items := []
export var puzzles_solves := 0
export var unlocked_levels := [
	0, 1, 3
]
export var current_subway_stop := 3

func save_data() -> void:
	print("Saving data at ", get_save_path())
	if ResourceSaver.save(get_save_path(), self) != OK:
		print("error saving")

# stole from GDQuest

func load_data() -> Resource:
	print("Loading data at ", get_save_path())
	var save_path := get_save_path()
	if ResourceLoader.has_cached(save_path):
		return ResourceLoader.load(save_path, "", true)

	var file := File.new()
	if file.open(save_path, File.READ) != OK:
		printerr("Couldn't read file " + save_path)
		return null

	var data := file.get_buffer(file.get_len())
	file.close()


	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_buffer(data)
	file.close()


	var save = ResourceLoader.load(tmp_file_path, "", true)

	save.take_over_path(save_path)


	var directory := Directory.new()
	if directory.remove(tmp_file_path) != OK:
		print("error")
	return save

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"

static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension

static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())
