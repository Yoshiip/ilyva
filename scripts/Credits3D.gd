extends Spatial


var bonus_o := 0.0

func _ready() -> void:
	$Canvas/Container/Logo.modulate.a = 0.0
	yield(get_tree().create_timer(1.0), "timeout")
	$AnimationPlayer.play("Camera")
	Engine.time_scale = 1.0
	$Timer.start()

func _process(delta: float) -> void:
	$Pillars.translation.x += delta * (10.0 + bonus_o)
	bonus_o *= 0.8
	$Canvas/Container/Panel/Credits.rect_position.y -= delta * 52.0
	if $Pillars.translation.x > 80.0:
		$Pillars.translation.x -= 80.0

	$Canvas/Container/Logo.rect_pivot_offset = $Canvas/Container/Logo.rect_size / 2.0

func _on_Timer_timeout() -> void:
	bonus_o = 50.0


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	get_tree().change_scene("res://scenes/Menu.tscn")
