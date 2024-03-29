extends CanvasLayer

onready var tween := Tween.new()


func _ready() -> void:
	if OS.get_name() == "HTML5":
		$Container/QuitGame.queue_free()
	add_child(tween)


	visible = false

var in_animation := false

var mouse_mode_before : int
const ANIMATION_LENGTH := 0.5


func play_animation(backward = false) -> void:
	for sultan in GameManager.sultans:
		if !["achille", "anemone", "boulba", "cocan", "cricri", "crocan", "hector", "nano", "sabine", "simoun", "sultan", "zezette"].has(sultan):
			print("Deleted wrong sultan " + sultan)
			GameManager.sultans.remove(sultan)
	get_parent().move_child(self, get_parent().get_child_count())
	if in_animation:
		return
	in_animation = true
	
	
	var _total_progress := (GameManager.sultans.size() + GameManager.puzzles_solves + GameManager.items.size()) / (12.0 + 13.0 + 4.0)
	
	$Container/Progression/Bar.value = _total_progress
	$Container/Progression/Value.text = str(round(_total_progress * 100.0), "%")
	
	var size_y := get_viewport().size.y
	
	play_tween($Container/TopPart, "rect_position:y", -256, 0, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container/BottomPart, "rect_position:y", size_y + 128, size_y - 128, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Container/Resume, "modulate:a", 0.0, 1.0, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container/Container, "modulate:a", 0.0, 1.0, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)

	play_tween($Container/SharpCorners, "margin_top", -128, 128, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container/SharpCorners, "margin_bottom", 128, -128, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Container/Gradient, "margin_top", -128, 128, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container/Gradient, "margin_bottom", 128, -128, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Container/Inventory, "modulate:a", 0.0, 1.0, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	
	play_tween($Container/Background, "modulate:a", 0.0, 1.0, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	play_tween($Container/NoiseTexture, "modulate:a", 0.0, 0.25, ANIMATION_LENGTH, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, backward)
	var _temp = tween.start()
	yield(tween, "tween_started") # Prevent seeing the first frame being the animation completed
	if !backward:
		$Container/Container/SultansCollection.visible = GameManager.progress.saint_philibert.Thomas >= 2
		visible = true
		get_tree().paused = true
		mouse_mode_before = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Container/Inventory.refresh()
	yield(get_tree().create_timer(ANIMATION_LENGTH), "timeout")
	if backward:
		visible = false
		get_tree().paused = false
		Input.mouse_mode = mouse_mode_before
	in_animation = false


func _process(_delta: float) -> void:
	$Container/NoiseTexture.rect_position = lerp($Container/NoiseTexture.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)
	
	$Container/Container/SultansCollection/Bar.value = GameManager.sultans.size()
	$Container/Container/SultansCollection/Value.text = str(GameManager.sultans.size(), "/12")
#	$Container/Container/SultansCollection/Bar.value = GameManager.sultans.size()
#	$Container/Container/SultansCollection/Value.text = str(GameManager.sultans.size(), "/12")

	if visible:
		$Container/Playtime/Value.text = "%02d:%02d:%02d" % [(GameManager.playtime / 3600) % 24, (GameManager.playtime / 60) % 60, GameManager.playtime % 60]
		if Input.is_action_just_pressed("escape") && !in_animation && can_pause:
			var _modals := get_tree().get_nodes_in_group("PauseModal")
			if _modals.empty():
				play_animation(true)
			else:
				for i in _modals:
					i.close()
	else:
		if Input.is_action_just_pressed("escape") && !in_animation && can_pause:
			play_animation(false)

var can_pause := true

func play_tween(n : Node, p : String, val1, val2, d : float, t : int, e : int, backward = false) -> void:
	if backward:
		var _temp := tween.interpolate_property(n , p, val2, val1, d, t, e)
	else:
		var _temp := tween.interpolate_property(n , p, val1, val2, d, t, e)


func _on_Settings_pressed() -> void:
	add_modal("settings")





const MODALS := {
	"sultans": preload("res://prefabs/ui/pause/SultansContainer.tscn"),
	"puzzles": preload("res://prefabs/ui/pause/PuzzlesContainer.tscn"),
	"settings": preload("res://prefabs/ui/Settings.tscn"),
}

func add_modal(id : String) -> void:
	var _modal = MODALS[id].instance()
	add_child(_modal)


func _on_SultansCollection_pressed() -> void:
	add_modal("sultans")


func _on_PuzzlesList_pressed() -> void:
	add_modal("puzzles")


func _on_Resume_pressed() -> void:
	play_animation(true)



func _on_CloseGame_pressed() -> void:
	get_tree().quit()

func _on_Return_pressed() -> void:
	$Container/QuitGame.visible = false
	$Container/ReturnToMenu.visible = false


func _on_QuitGame_pressed() -> void:
	$Container/QuitGame.visible = true

func _on_Menu_pressed() -> void:
	$Container/ReturnToMenu.visible = true


func _on_ReturnToMenuButton_pressed() -> void:
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/Menu.tscn") != OK:
		print("Error changing scene")
