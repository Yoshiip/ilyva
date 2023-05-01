extends Node2D


var animation : VideoPlayer

onready var transition := preload("res://prefabs/Transition.tscn").instance()

func _ready() -> void:
	MusicManager.start_music("")
	add_child(transition)
	add_child(Dialogic.start(str("iut/Bastum/", GameManager.progress["iut"]["Bastum"])))
	
	if GameManager.extra:
		animation = preload("res://extra/prefabs/AnimationVideo.tscn").instance()
		add_child(animation)
		animation.connect("finished", self, "_on_Animation_finished")
		move_child(animation, 2)

func play_animation(anim_name : String) -> void:
	$AnimationPlayer.play(anim_name)
	

var writing := false



func _process(delta: float) -> void:
	if writing && $Canvas/Blur/Win/Text.focus_mode != Control.FOCUS_NONE:
		$Canvas/Blur/Win/Bar.value -= delta
		$Canvas/Blur/Win/Text.grab_focus()
	if is_instance_valid(animation):
		var _max = 1.5 / min(3840.0 / get_viewport().size.x, 2160.0 / get_viewport().size.y)
		animation.rect_size = Vector2(3840, 2160)
		animation.rect_scale = Vector2.ONE * _max
		
		animation.rect_position = -animation.rect_size / 2.0
	else:
		var _max = max(1.5 / (1920.0 / get_viewport().size.x), 1.5 / 
		
		(1080.0 / get_viewport().size.y))
		$Background.scale.x = _max
		$Background.scale.y = _max

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Win":
		$Camera.zoom = Vector2(1.5, 1.5)
		writing = true
	elif anim_name == "Reveal":
		GameManager.progress["iut"]["Bastum"] += 1
		add_child(Dialogic.start(str("iut/Bastum/", GameManager.progress["iut"]["Bastum"])))
	elif anim_name == "End":
		GameManager.progress["game_finished"] = true
		get_tree().change_scene("res://scenes/Credits3D.tscn")


func load_puzzle(puzzle_id : String) -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/" + puzzle_id + ".tres"))
	GameManager.context_before_puzzle = {
		"scene": get_tree().current_scene.filename,
	}
	GameManager.progress["iut"]["Bastum"] += 1
	transition.transition_to_scene("res://scenes/puzzles/StartAnimation.tscn")

func _on_Animation_finished() -> void:
	animation.play()


var text := "rm -rf bastum"

func _on_Text_text_changed(new_text: String) -> void:
	$Canvas/Blur/Win/Text.text = ""
	
	if text == new_text:
		$Canvas/Blur/Win/Text.focus_mode = Control.FOCUS_NONE
		$AnimationPlayer.play("End")
	
	$Camera.zoom = Vector2(1.5, 1.5)
	$Typing.pitch_scale = 1.0
	$Typing.volume_db = 0
	for c in new_text.length():
		if text[c] == new_text[c]:
			$Canvas/Blur/Win/Text.text += text[c]
			$Canvas/Blur/Win/Text.caret_position = $Canvas/Blur/Win/Text.text.length()
			$Camera.zoom -= Vector2(0.03, 0.03)
			$Typing.pitch_scale += 0.1
			$Typing.volume_db += 3
		else:
			return
	$Typing.play()
#func increment_progress() -> void:
#	GameManager.progress["iut"]["Bastum"] += 1
