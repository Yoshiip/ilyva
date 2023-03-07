extends Spatial

onready var map: Spatial = $CanvasLayer/Control/MinimapContainer/Viewport/Map

func _process(delta: float) -> void:
	map.get_node("Subway").progress = $CanvasLayer/Control/ViewportContainer/Viewport/MovingSubway.offset
