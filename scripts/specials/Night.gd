extends Control

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	MusicManager.start_music("")
	add_child(Dialogic.start("beaux_arts/Night/0"))
	
