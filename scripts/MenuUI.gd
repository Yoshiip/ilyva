extends Control

#onready var noise_texture_2: TextureRect = $Canvas/Container/ColorRect/NoiseTexture
onready var noise_texture_3: TextureRect = $Canvas/Container/NoiseTexture
onready var noise_texture: TextureRect = $Canvas/Container/NoiseTexture

onready var animation_player: AnimationPlayer = $"Canvas/Container/3D/ViewportContainer/Spatial/AnimationPlayer"


export var game_quality := false

onready var world_environment: WorldEnvironment = $"Canvas/Container/3D/ViewportContainer/Spatial/Spatial/WorldEnvironment"


onready var noise := NoiseTexture.new()

func _ready() -> void:
	noise.noise = OpenSimplexNoise.new()


func _process(delta: float) -> void:
	world_environment.environment.ssao_enabled = GameManager.settings["game_quality"] == 1
	world_environment.environment.glow_enabled = GameManager.settings["game_quality"] == 1
	world_environment.environment.ss_reflections_enabled = GameManager.settings["game_quality"] == 1
	
	if Input.is_action_just_pressed("ui_accept") && animation_player.is_playing():
		
		animation_player.seek(7.4, true)
		$Music.seek(6.4)

	noise_texture.rect_position = lerp(noise_texture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)
#func _process(delta: float) -> void:
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


func _on_LowQuality_pressed() -> void:
	GameManager.settings["game_quality"] = 0 if GameManager.settings["game_quality"] == 1 else 0
