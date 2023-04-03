extends Panel

onready var tween := Tween.new()

func _ready() -> void:
	add_to_group("PauseModal")
	add_child(tween)
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.5)
	tween.start()
	if is_instance_valid(get_node("Close")):
		$Close.connect("pressed", self, "close")

func close() -> void:
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5)
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
