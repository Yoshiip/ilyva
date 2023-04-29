extends CanvasLayer

func _ready() -> void:
	var new_dialog = Dialogic.start("intro/intro")
	get_tree().current_scene.add_child(new_dialog)

func dialogue_event(arg : String) -> void:
	match arg:
		"enter_subway":
			$Background.texture = load("res://images/backgrounds/intro/subway.jpg")
		"animation":
			$AnimationPlayer.play("AnimExplosion")
			$AnimationPlayer.seek(0.0)
		"rallumage":
			$AnimationPlayer.play("SubwaySeRallume")
			$AnimationPlayer.seek(0.0)
		"end":
			if get_tree().change_scene("res://scenes/StPhilibert/Station.tscn") != OK:
				print("error intro")
