extends Panel

var skipped := false
var time := 0.0

func _ready() -> void:
	modulate.a = 0.0
	if skipped:
		$Title.text = "Énigme passée"
	$TotalTime.text = str("Puzzle terminé en\n", "%02d:%02d" % [floor(time / 60.0), floor(fmod(time, 60.0))])
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0)
	$Tween.start()

func _process(delta: float) -> void:
	$Pattern.rect_position += Vector2.ONE * delta * 64.0
	if $Pattern.rect_position.x > 0:
		$Pattern.rect_position -= Vector2.ONE * 128.0


func _on_ReturnButton_pressed() -> void:
	if get_tree().change_scene(GameManager.context_before_puzzle.scene) != OK:
		print("Error changing scene")
