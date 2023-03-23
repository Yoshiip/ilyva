extends Camera2D




onready var subway: Sprite = $"../Line1/Path/Subway"

func _process(delta: float) -> void:
	
	position = subway.global_position
