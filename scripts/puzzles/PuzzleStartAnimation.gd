extends Control

onready var circle: TextureRect = $Canvas/Container/Circle
onready var circles_particle: CPUParticles2D = $CirclesParticle
onready var portrait: TextureRect = $Canvas/Container/Portrait


func _ready() -> void:
	$Canvas/Container/Portrait.texture = GameManager.current_puzzle.portrait
	$Canvas/Container/Label.text = GameManager.current_puzzle.start_phrase
	$Canvas/Container/Number.text = str("00", GameManager.current_puzzle.get_puzzle_id())
	$Tween.interpolate_property($Canvas/Container/CircleTransition.material, "shader_param/Canvas/Container/Circle_size", 0.0, 1.05, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(circle, "modulate", Color.transparent, circle.modulate, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(portrait, "rect_scale", Vector2.ONE * 1.25, Vector2.ONE, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(circle, "rect_scale", Vector2.ZERO, Vector2.ONE, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Canvas/Container/Label, "percent_visible", 0.0, 1.0, 2.0, 0, 2)
	$Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	$Tween.interpolate_property($Canvas/Container/CircleTransition.material, "shader_param/Canvas/Container/Circle_size", 1.05, 0.0, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	if get_tree().change_scene("res://scenes/puzzles/Puzzle.tscn") != OK:
		print("Error changing scene")


#onready var base_position = $Canvas/Container/Pattern.rect_position

func _input(event: InputEvent) -> void:
	if event.is_action_released("escape"):
		if get_tree().change_scene("res://scenes/puzzles/Puzzle.tscn") != OK:
			print("Error changing scene")

func _process(delta: float) -> void:
#	pattern.rect_rotation = lerp(pattern.rect_rotation, rand_range(-10, 10), delta * 2.5)
#	pattern.rect_position = lerp(base_position, base_position + Vector2(rand_range(-1, 1), rand_range(-1, 1)) * 15.0, 0.2)
	circle.rect_rotation = lerp(circle.rect_rotation, rand_range(-180, 180), delta * 2.5)
	circles_particle.position = (get_global_mouse_position() * 0.1).limit_length(50)
	$Camera.zoom.y = 640.0 / get_viewport().size.y
	$Camera.zoom.x = 640.0 / get_viewport().size.y
