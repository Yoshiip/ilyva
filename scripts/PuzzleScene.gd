extends Node2D


var pause_menu

var total_time := 0.0

onready var puzzle : Puzzle
onready var tween := Tween.new()
onready var puzzle_end_screen := preload("res://prefabs/puzzles/PuzzleEndScreen.tscn").instance()

var puzzle_handler : Node = null


func _ready() -> void:
	add_child(tween)
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	add_child(pause_menu)

	puzzle = GameManager.current_puzzle
	$Canvas/Container/ModalsManager.ready()
	
	if puzzle.get_puzzle_id() == "13": # last puzzle
		yield(get_tree().create_timer(5.0), "timeout")
		add_child(Dialogic.start("last_puzzle/start"))
	
	puzzle_handler = Node.new()
	puzzle_handler.name = "PuzzleHandler"
	
	
	puzzle_handler.script = load("res://scripts/puzzles/setup/" + puzzle.get_puzzle_id() + ".gd")
	add_child(puzzle_handler)


onready var pattern: Sprite = $Wallpaper/Pattern

func _process(delta: float) -> void:
	total_time += delta
	var time = Time.get_time_dict_from_system()
	if time.second % 2 == 0:
		$Canvas/Container/Footer/Time.text = "%02d:%02d" % [time.hour, time.minute]
	else:
		$Canvas/Container/Footer/Time.text = "%02d %02d" % [time.hour, time.minute]
	$LightMask.position = lerp($LightMask.position, get_global_mouse_position(), delta * 2.0)
	pattern.position.x += delta * 50.0
	pattern.position.y += delta * 50.0
	if pattern.position.x > 1178:
		pattern.position.x -= 1178
	if pattern.position.y > 850:
		pattern.position.y -= 850

func change_background_color(color : Color) -> void:
	var _temp := tween.interpolate_property($Wallpaper, "modulate", $Wallpaper.modulate, color, 3.0)
	_temp = tween.start()

func skip() -> void:
	if puzzle.get_puzzle_id() == "0":
		get_tree().change_scene("res://scenes/Menu.tscn")
	puzzle_ended(true)

func puzzle_ended(skipped = false) -> void:
	if !skipped:
		yield(get_tree().create_timer(1.0), "timeout")
	puzzle_end_screen.time = total_time
	puzzle_end_screen.skipped = skipped
	$Canvas/Container.add_child(puzzle_end_screen)
	puzzle_end_screen.get_node("ReturnButton").grab_focus() # pour éviter que le joueur malicieux continuent d'écrire dans le terminal

var timer : ProgressBar

func add_timer() -> void:
	change_background_color(Color.red)
	timer = load("res://prefabs/ui/TimerOfDeath.tscn").instance()
	$Canvas/Container.add_child(timer)

func prevent_bomb() -> void:
	timer.prevent()


func _on_CloseAll_pressed() -> void:
	for modal in $Canvas/Container/ModalsManager.get_children():
		modal.close()

func _on_Restart_pressed() -> void:
	if get_tree().reload_current_scene() != OK:
		print("error restarting")
