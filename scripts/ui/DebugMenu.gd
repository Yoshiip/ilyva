extends CanvasLayer


func _ready() -> void:
	_on_Slider_value_changed(Engine.time_scale)

func _process(delta: float) -> void:
	$Container/FPS.text = str(Engine.get_frames_per_second(), "fps")


func _on_Slider_value_changed(value: float) -> void:
	Engine.time_scale = value
	$Container/Speedhack/Slider.value = value
	$Container/Speedhack/Label.text = str("Speedhack x", value)


func _on_Button_pressed() -> void:
	get_tree().change_scene(str("res://scenes/", $Container/Scene/Text.text, ".tscn"))


func _on_Skip_pressed() -> void:
	if get_tree().current_scene.name == "Puzzle":
		get_tree().current_scene.skip()


func _on_Spinbox_value_changed(value: float) -> void:
	GameManager.current_puzzle = load(str("res://resources/puzzles/", int(value), ".tres"))
