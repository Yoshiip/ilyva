extends Area2D


export var sultan_id := ""

func _ready() -> void:
	
	$Icon.texture = load("res://images/sultans/" + sultan_id + ".png")
	
	if GameManager.sultans.has(sultan_id):
		queue_free()

func interact() -> void:
	GameManager.add_sultan(sultan_id)
	queue_free()
