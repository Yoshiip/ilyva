extends Area2D


export var count := 7


export(NodePath) var sibling

var i = 0
func _ready() -> void:
	if GameManager.progress.beaux_arts.Sultan < 2:
		queue_free()

func interact() -> void:
	i += 1
	if i >= count && get_node(sibling).i >= get_node(sibling).count:
		get_tree().change_scene("res://scenes/Pong.tscn")
