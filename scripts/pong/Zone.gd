extends Area2D

export var for_enemy := false

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	$CollisionShape2D.disabled = false



func _on_Zone_body_entered(body: Node) -> void:
	if body.name == "Ball":
		get_tree().current_scene.score(for_enemy)
