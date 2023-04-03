extends Control


onready var noise_texture: TextureRect = $Canvas/Container/Grain

onready var animation_player: AnimationPlayer = $"Canvas/Container/3D/Container/Viewport/AnimationPlayer"
onready var camera: Camera = $"Canvas/Container/3D/Container/Viewport/Menu/Camera"

onready var world_environment: WorldEnvironment = $"Canvas/Container/3D/Container/Viewport/Menu/WorldEnvironment"


onready var Settings := preload("res://prefabs/ui/Settings.tscn")

onready var noise := NoiseTexture.new()

func _ready() -> void:
	noise.noise = OpenSimplexNoise.new()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && animation_player.is_playing():
		
		animation_player.seek(7.4, true)
		$Music.seek(6.4)

	noise_texture.rect_position = lerp(noise_texture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://scenes/Map.tscn")

func _on_Settings_pressed() -> void:
	camera.switch_camera()
	$Canvas/Container.add_child(Settings.instance())

func _on_Play_pressed() -> void:
	get_tree().change_scene("res://scenes/Terminal.tscn")


func _on_Metro_pressed() -> void:
	get_tree().change_scene("res://scenes/3d/StationLevel.tscn")


func settings_updated() -> void:
	$"Canvas/Container/3D".visible = !GameManager.settings.disable_3d
	match GameManager.settings["3d_quality"]:
		0:
			world_environment.environment.ssao_quality = Environment.SSAO_QUALITY_LOW
			world_environment.environment.glow_high_quality = false
			world_environment.environment.ss_reflections_enabled = false
		1:
			world_environment.environment.ssao_quality = Environment.SSAO_QUALITY_MEDIUM
			world_environment.environment.glow_high_quality = false
			world_environment.environment.ss_reflections_enabled = true
			world_environment.environment.ss_reflections_max_steps = 64
		2:
			world_environment.environment.ssao_quality = Environment.SSAO_QUALITY_HIGH
			world_environment.environment.glow_high_quality = true
			world_environment.environment.ss_reflections_enabled = true
			world_environment.environment.ss_reflections_max_steps = 512



func _on_Chiba_pressed() -> void:
	get_tree().change_scene("res://scenes/StPhilibert/MetroOutside.tscn")
