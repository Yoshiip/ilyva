extends Node

var MUSICS := {}

#var MUSICS := {
#	"night": preload("res://extra/musics/night.mp3"),
#	"chiba": preload("res://extra/musics/chiba.mp3"),
#	"puzzle": preload("res://extra/musics/puzzle.mp3"),
#	"subway": preload("res://extra/musics/subway.mp3"),
#	"rat": preload("res://extra/musics/rat.mp3"),
#	"iut": preload("res://extra/musics/iut.mp3"),
#	"bomb": preload("res://extra/musics/bomb.mp3"),
#}

func _ready() -> void:
	if GameManager.extra:
		for music in ["night", "chiba", "puzzle", "puzzle_2", "subway", "rat", "iut", "bomb", "menu", "scary", "saint_philibert"]:
			MUSICS[music] = load("res://extra/musics/" + music + ".mp3")

onready var GameMusic := preload("res://prefabs/GameMusic.tscn")

var current_stream : AudioStreamPlayer

var current_music_id : String

func start_music(id, fade_time = "5.0", db = -20) -> void:
	if !GameManager.extra:
		return
	if id == "puzzle" && randi() % 2 == 0:
		id = "puzzle_2"
	if current_music_id == id:
		return
	if id == "":
		if is_instance_valid(current_stream):
			current_stream.fade_out()
		return
	var stream := GameMusic.instance()
	stream.stream = MUSICS[id]
	
	stream.fade_time = float(fade_time)
	stream.max_db = db
	
	current_music_id = id
	add_child(stream)
	stream.fade_in()
	if is_instance_valid(current_stream):
		current_stream.fade_out()
	
	current_stream = stream
