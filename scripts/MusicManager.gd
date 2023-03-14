extends Node

const MUSICS := {
	"night": preload("res://audios/musics/night.mp3"),
}


func start_music(_id) -> void:
	var stream := AudioStreamPlayer.new()
	stream.stream = MUSICS.night
	stream.autoplay = true
	stream.volume_db = -20
	add_child(stream)
