extends Control

const VERSION := "1.1"


onready var noise_texture: TextureRect = $Canvas/Container/Grain

onready var transition := preload("res://prefabs/Transition.tscn").instance()

onready var Settings := preload("res://prefabs/ui/Settings.tscn")

onready var noise := NoiseTexture.new()

func _ready() -> void:
	MusicManager.start_music("menu")
	if OS.get_name() == "HTML5":
		$Canvas/Container/Buttons/HBoxContainer/Quit.queue_free()
#	$Canvas/Container/Buttons/HBoxContainer/Continue.visible = SaveData.save_exists()
	if !GameManager.extra:
		$Canvas/Container/TopPart/IlyvaLogoRed/ExtraLogo.queue_free()
	if GameManager.progress["game_finished"]:
		$Canvas/Container/TopPart/IlyvaLogoRed/BlueDot.modulate = Color("FF9900")
		$Canvas/Container/TopPart/IlyvaLogoRed/GreenDot.modulate = Color("FF9900")
		$Canvas/Container/TopPart/IlyvaLogoRed/RedDot.modulate = Color("FF9900")
	$Canvas/Container/Control/Panel/Version.text = str("ILYVA v", VERSION, "\n", OS.get_name().to_upper())
	noise.noise = OpenSimplexNoise.new()
	
	get_tree().connect("screen_resized", self, "_screen_resized")
	_screen_resized()
	add_child(transition)

var timer := 0.0
func _screen_resized() -> void:
	var _size := get_viewport().size
	$Canvas/Container/Control/Panel/WindowSize.text = str(_size.x, "x", _size.y)

func _process(delta: float) -> void:
	timer += delta
	
	$Canvas/Container/Control/Panel/Timer.text = "%02d:%02d:%s" % [int(floor(timer / 60.0)) % 60, int(fmod(floor(timer), 60.0)), str((timer - int(timer))).left(4).right(2)]
	$Canvas/Container/Control/Panel/Dot.modulate = Color.red if fmod(timer, 2.0) > 1.0 else Color.black
	
	noise_texture.rect_position = lerp(noise_texture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)


func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	if get_tree().change_scene("res://scenes/Credits.tscn") != OK:
		print("error while changing scene")

func _on_Settings_pressed() -> void:
	$Canvas/Container.add_child(Settings.instance())

func _on_Play_pressed() -> void:
	if GameManager.progress["saint_philibert"]["can_use_subway"]:
		transition.transition_to_scene("res://scenes/SubwaySimplified.tscn")
	else:
		transition.transition_to_scene("res://scenes/Intro.tscn")

func _on_Continue_pressed() -> void:
	pass
#	GameManager.load_save()
#	if get_tree().change_scene("res://scenes/SubwaySimplified.tscn") != OK:
#		print()

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



func _on_LineEdit_text_entered(new_text: String) -> void:
	get_tree().change_scene(new_text)


func _on_Playground_pressed() -> void:
	GameManager.context_before_puzzle = {
		"scene": get_tree().current_scene.filename
	}
	GameManager.current_puzzle = load("res://resources/puzzles/0.tres")
	transition.transition_to_scene("res://scenes/puzzles/Puzzle.tscn")
