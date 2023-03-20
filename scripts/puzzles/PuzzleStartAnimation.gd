extends Control

onready var circle: TextureRect = $Canvas/Container/Circle
onready var circles_particle: CPUParticles2D = $CirclesParticle
onready var portrait: TextureRect = $Canvas/Container/Portrait
onready var pattern: TextureRect = $Canvas/Container/Pattern


func _ready() -> void:
	if GameManager.puzzle_id != -1:
		portrait.texture = GameManager.puzzles[GameManager.puzzle_id].portrait
	$Tween.interpolate_property($Canvas/Container/CircleTransition.material, "shader_param/Canvas/Container/Circle_size", 0.0, 1.05, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(circle, "modulate", Color.transparent, circle.modulate, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(portrait, "rect_scale", Vector2.ONE * 1.25, Vector2.ONE, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(circle, "rect_scale", Vector2.ZERO, Vector2.ONE, 2.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(3.5), "timeout")
	$Tween.interpolate_property($Canvas/Container/CircleTransition.material, "shader_param/Canvas/Container/Circle_size", 1.05, 0.0, 1.0, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene("res://scenes/puzzles/Puzzle.tscn")


onready var base_position = $Canvas/Container/Pattern.rect_position

func _process(delta: float) -> void:
	pattern.rect_rotation = lerp(pattern.rect_rotation, rand_range(-10, 10), delta * 2.5)
	pattern.rect_position = lerp(base_position, base_position + Vector2(rand_range(-1, 1), rand_range(-1, 1)) * 15.0, 0.2)
	circle.rect_rotation = lerp(circle.rect_rotation, rand_range(-180, 180), delta * 2.5)
	circles_particle.position = (get_global_mouse_position() * 0.1).clamped(50)
	$Camera.zoom.y = 640.0 / get_viewport().size.y
	$Camera.zoom.x = 640.0 / get_viewport().size.y
