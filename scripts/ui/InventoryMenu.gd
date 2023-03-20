extends Control

onready var tween := Tween.new()


func _ready() -> void:
	add_child(tween)
	visible = false

var in_animation := false

var mouse_mode_before : int

func play_animation(backward = false) -> void:
	if in_animation:
		return
	in_animation = true
	
	var size_y := get_viewport().size.y
	
	play_tween($TopPart, "rect_position:y", -256, 0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($BottomPart, "rect_position:y", size_y + 128, size_y - 128, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Objective, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Resume, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)

	play_tween($SharpCorners, "margin_top", -128, 128, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($SharpCorners, "margin_bottom", 128, -128, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Gradient, "margin_top", -128, 128, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Gradient, "margin_bottom", 128, -128, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Inventory, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Background, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($NoiseTexture, "modulate:a", 0.0, 0.25, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	tween.start()
	yield(tween, "tween_started") # Prevent seeing the first frame being the animation completed
	if !backward:
		visible = true
		get_tree().paused = true
		mouse_mode_before = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	yield(get_tree().create_timer(1.0), "timeout")
	if backward:
		visible = false
		get_tree().paused = false
		Input.mouse_mode = mouse_mode_before
	in_animation = false


func _process(_delta: float) -> void:
	$NoiseTexture.rect_position = lerp($NoiseTexture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)
	$Container/SultansCollection/Bar.value = GameManager.sultans.size()
	$Container/SultansCollection/Value.text = str(GameManager.sultans.size(), "/12")

	if visible:
		if Input.is_action_just_pressed("escape") && !in_animation && can_pause:
			play_animation(true)
	else:
		if Input.is_action_just_pressed("escape") && !in_animation && can_pause:
			play_animation(false)

var can_pause := true

func play_tween(n : Node, p : String, val1, val2, d : float, t : int, e : int, backward = false) -> void:
	if backward:
		tween.interpolate_property(n , p, val2, val1, d, t, e)
	else:
		tween.interpolate_property(n , p, val1, val2, d, t, e)


func _on_Settings_pressed() -> void:
	$Settings.show()


func _on_SultansCollection_pressed() -> void:
	$Sultans.visible = true


func _on_PuzzlesList_pressed() -> void:
	$Puzzles.visible = true


func _on_Resume_pressed() -> void:
	play_animation(true)



func _on_CloseGame_pressed() -> void:
	get_tree().quit()

func _on_Return_pressed() -> void:
	$QuitGame.visible = false
	$ReturnToMenu.visible = false


func _on_QuitGame_pressed() -> void:
	$QuitGame.visible = true


func _on_SultansMenuGoBack_pressed() -> void:
	$Sultans.visible = false


func _on_PuzzlesMenuGoBack_pressed() -> void:
	$Puzzles.visible = false


func _on_Menu_pressed() -> void:
	$ReturnToMenu.visible = true


func _on_ReturnToMenuButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Menu.tscn")
