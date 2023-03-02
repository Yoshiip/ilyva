extends Control

onready var noise_texture_1: TextureRect = $Canvas/Container/Panel/ViewportContainer/NoiseTexture
#onready var noise_texture_2: TextureRect = $Canvas/Container/ColorRect/NoiseTexture
onready var noise_texture_3: TextureRect = $Canvas/Container/NoiseTexture

onready var animation_player: AnimationPlayer = $"Canvas/Container/3D/ViewportContainer/Spatial/Spatial/AnimationPlayer"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		animation_player.seek(7.6, true)

#func _process(delta: float) -> void:
#	noise_texture_1.rect_position = lerp(noise_texture_1.rect_position, Vector2(rand_range(-5, 5), rand_range(-5, 5)), 0.1)
#	noise_texture_2.rect_position = lerp(noise_texture_2.rect_position, Vector2(rand_range(-5, 5), rand_range(-5, 5)), 0.8)
#	noise_texture_3.rect_position = lerp(noise_texture_3.rect_position, Vector2(rand_range(-50, 50), rand_range(-50, 50)), 0.5)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://scenes/Map.tscn")


func _on_Settings_pressed() -> void:
	get_tree().change_scene("res://scenes/BeauxArts/Surface.tscn")


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://scenes/Terminal.tscn")


func _on_Metro_pressed() -> void:
	get_tree().change_scene("res://scenes/3d/StationLevel.tscn")
