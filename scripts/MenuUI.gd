extends Control

const VERSION := "1.0"


onready var noise_texture: TextureRect = $Canvas/Container/Grain


onready var Settings := preload("res://prefabs/ui/Settings.tscn")

onready var noise := NoiseTexture.new()

func _ready() -> void:
	$Canvas/Container/Version.text = str(VERSION, " (", OS.get_name(), ")")
	noise.noise = OpenSimplexNoise.new()

func _process(_delta: float) -> void:
	noise_texture.rect_position = lerp(noise_texture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	if get_tree().change_scene("res://scenes/Credits.tscn") != OK:
		print("error while changing scene")

func _on_Settings_pressed() -> void:
	$Canvas/Container.add_child(Settings.instance())

func _on_Play_pressed() -> void:
	if get_tree().change_scene("res://scenes/Intro.tscn") != OK:
		print("error while changing scene")

func _on_VideoPlayer_finished() -> void:
	$"%VideoPlayer".play()


func _on_Website_pressed() -> void:
	if OS.shell_open("https://ilyva.sciencesky.fr/") != OK:
		print("shell error")

func _on_Github_pressed() -> void:
	if OS.shell_open("https://github.com/Yoshiip/ilyva") != OK:
		print("shell error")

func _on_DebugPuzzle_pressed() -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/", $Canvas/Container/DebugPuzzle/SpinBox.value, ".tres"))
	if get_tree().change_scene("res://scenes/puzzles/Puzzle.tscn") != OK:
		print("error menu")
