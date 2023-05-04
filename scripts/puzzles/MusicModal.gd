extends "res://scripts/ui/Modal.gd"

const TRACKLIST := [
	"puzzle",
	"puzzle_2",
	"night",
	"chiba",
	"subway",
	"rat",
	"iut"
]

func _ready() -> void:
	update_play_icon()

onready var pause_icon := preload("res://images/ui/pause.png")
onready var play_icon := preload("res://images/ui/play.png")
func _on_Previous_pressed() -> void:
	if TRACKLIST.has(MusicManager.current_music_id):
		var _index : String = TRACKLIST[(TRACKLIST.find(MusicManager.current_music_id) - 1) % TRACKLIST.size()]
		MusicManager.start_music(_index, "1.0")
	else:
		MusicManager.start_music(TRACKLIST[0], "1.0")

func _process(delta: float) -> void:
	if is_instance_valid(MusicManager.current_stream):
		$Content/Panel/Container/NowPlaying.text = str(MusicManager.current_music_id, ".mp3")
	else:
		$Content/Panel/Container/NowPlaying.text = "No music"
	
func update_play_icon() -> void:
	if is_instance_valid(MusicManager.current_stream) && MusicManager.current_stream.stream_paused:
		$Content/Panel/Container/Container/PlayPause.texture_normal = play_icon
		$Content/Panel/Container/Container/PlayPause.texture_hover = play_icon
		$Content/Panel/Container/Container/PlayPause.texture_pressed = play_icon
	else:
		$Content/Panel/Container/Container/PlayPause.texture_normal = pause_icon
		$Content/Panel/Container/Container/PlayPause.texture_hover = pause_icon
		$Content/Panel/Container/Container/PlayPause.texture_pressed = pause_icon

func _on_PlayPause_pressed() -> void:
	if is_instance_valid(MusicManager.current_stream):
		MusicManager.current_stream.stream_paused = !MusicManager.current_stream.stream_paused
	else:
		MusicManager.start_music(TRACKLIST[0], "1.0")
	update_play_icon()

func _on_Next_pressed() -> void:
	if TRACKLIST.has(MusicManager.current_music_id):
		var _index : String = TRACKLIST[(TRACKLIST.find(MusicManager.current_music_id) + 1) % TRACKLIST.size()]
		MusicManager.start_music(_index, "1.0")
	else:
		MusicManager.start_music(TRACKLIST[0], "1.0")
