extends ProgressBar

var fake := false

func _ready() -> void:
	MusicManager.start_music("bomb", 1.0, -5)
	print(GameManager.progress["iut"]["CDI"])
	fake = GameManager.progress["iut"]["CDI"] == 1



func _process(delta: float) -> void:
	value -= delta
	modulate = lerp(Color.white, Color.red, (cos(value * 10.0) + 1.0) / 2.0 )
	$Time.text = str(stepify(value, 0.01), "s")
	if value <= 0.0 && !fake:
		get_tree().change_scene("res://scenes/IUT/GameOver.tscn")
	if value <= 1.0 && fake:
		get_tree().current_scene.add_child(Dialogic.start("last_puzzle/mathieu"))
		set_process(false)

func prevent() -> void:

	self_modulate.a = 0.25
	$Label.self_modulate.a = 0.25
	$Time.self_modulate.a = 0.25
	$Mathieu.visible = true
	set_process(false)
#	mouse_filter = Control.MOUSE_FILTER_IGNORE
	MusicManager.start_music("puzzle", 1.0)
	queue_free()
