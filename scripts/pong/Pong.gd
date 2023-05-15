extends Node2D


var player_score := 0

var bot_score := 0

func _ready() -> void:
	get_tree().connect("screen_resized", self, "_restart")

func _restart() -> void:
	get_tree().reload_current_scene()

func score(for_player) -> void:
	if for_player:
		player_score += 1
	else:
		bot_score += 1
	$Ball.restart()
	if max(player_score, bot_score) >= 3:
		get_tree().change_scene("res://scenes/IUT/Station.tscn")

func _process(delta: float) -> void:
	$Label.text = str(player_score, " - ", bot_score)
	$Player.position.x = -(get_viewport().size.x) + 200
	$Bot.position.x = (get_viewport().size.x) - 200
	$Walls/Top.position.y = -(get_viewport().size.y)
	$Walls/Bottom.position.y = (get_viewport().size.y)
