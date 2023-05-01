extends Control

func _ready() -> void:
	MusicManager.start_music("")
	GameManager.progress["iut"]["Bastum"] = 0
	add_child(Dialogic.start("last_puzzle/game_over"))
