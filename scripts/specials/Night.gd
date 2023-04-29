extends Control

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	add_child(Dialogic.start("beaux_arts/Night/0"))
