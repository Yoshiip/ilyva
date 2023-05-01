extends AudioStreamPlayer


var tween := Tween.new()

var fade_time := 5.0
var max_db := -20

func _ready() -> void:
	add_child(tween)

func fade_in() -> void:
	var _temp := tween.interpolate_property(self, "volume_db", -80, max_db, fade_time)
	_temp = tween.start()
	yield(get_tree().create_timer(1.0), "timeout")
	play()

func fade_out() -> void:
	var _temp := tween.interpolate_property(self, "volume_db", volume_db, -80, fade_time)
	_temp = tween.start()
	yield(get_tree().create_timer(5.0), "timeout")
	queue_free()
