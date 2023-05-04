extends Area2D


export var sultan_id := ""

func _ready() -> void:
	if GameManager.sultans.has(sultan_id) || GameManager.progress["saint_philibert"]["Thomas"] <= 1:
		queue_free()
	
	$Icon.texture = load("res://images/sultans/" + sultan_id + ".png")
	

func interact() -> void:
	GameManager.add_sultan(sultan_id)
	queue_free()
