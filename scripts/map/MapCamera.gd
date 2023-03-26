extends Camera2D




onready var subway: Sprite = $"../Line/Path/Icon"

func _process(delta: float) -> void:
	position = subway.global_position
