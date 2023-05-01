class_name SaveData
extends Resource

const SAVE_GAME_BASE_PATH := "user://save"


var progress := {
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
		"Digicode": 0,
		"Clément": 0,
		"Manon": 0,
		"Chiba": 0,
		"Sultan": 0,
	},
	"pont_de_bois": {
		"Rat": 0,
	},
	"iut": {
		"CDI": 0,
		"Bureau": 0,
	}
}

var unlocked_levels := [
	3, 0
]
var current_subway_stop := 3
var one_time_interacts := []

func unlock_level(level_id : String) -> void:
	unlocked_levels.append(int(level_id))

var settings := {
	"3d_quality": 2, # 0 = low, 1 = medium, 2 = high
	"enable_3d": false,
	"fov": 70,
	"sensivity": 10.0
}


var sultans := []
var items := []

func save_data() -> void:
	if ResourceSaver.save(get_save_path(), self) != OK:
		print("error saving")

# stole from GDQuest

func load_data() -> Resource:
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
