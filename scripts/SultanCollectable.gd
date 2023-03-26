extends Area2D


export var sultan_id := ""

func _ready() -> void:
	if GameManager.sultans.has(sultan_id):
		queue_free()

func interact() -> void:
	GameManager.sultans.append(sultan_id)
	queue_free()
