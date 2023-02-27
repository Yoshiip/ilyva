extends Camera

onready var subway: Spatial = $"../Subway"

func _process(delta: float) -> void:
	translation = subway.get_child(0).translation + Vector3(0, 100, 20)
