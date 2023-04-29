extends Node2D

var progress := 0

onready var transition := preload("res://prefabs/Transition.tscn").instance()

func _ready() -> void:
	$Canvas.add_child(transition)
	add_child(Dialogic.start(str("iut/Bastum/", progress)))


func play_animation(anim_name : String) -> void:
	$AnimationPlayer.play(anim_name)
	

func _process(delta: float) -> void:
	var _max = max(1.5 / (1920.0 / get_viewport().size.x), 1.5 / (1080.0 / get_viewport().size.y))
	$Background.scale.x = _max
	$Background.scale.y = _max

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	progress += 1
	add_child(Dialogic.start(str("iut/Bastum/", progress)))

func load_puzzle(puzzle_id : String) -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/" + puzzle_id + ".tres"))
#	GameManager.context_before_puzzle = {
#		"scene": get_tree().current_scene.filename,
#		"path": current_dialogue_character.get_path(),
#		"id": current_dialogue_id,
#	}
	transition.transition_to_scene("res://scenes/puzzles/StartAnimation.tscn")
