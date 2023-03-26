extends "res://scripts/ui/Modal.gd"

func _process(delta: float) -> void:
	if !$Content/VideoPlayer.is_playing():
		$Content/VideoPlayer.play()
