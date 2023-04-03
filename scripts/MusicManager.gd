extends Node

const MUSICS := {}


func start_music(_id) -> void:
	var stream := AudioStreamPlayer.new()
	stream.stream = MUSICS.night
	stream.autoplay = true
	stream.volume_db = -20
	add_child(stream)
