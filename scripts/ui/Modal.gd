extends Panel

export var modal_name := ""
export var can_close := false

onready var tween := $Tween

func play_tween(n : Node, p : String, val1, val2, d : float, t = Tween.TRANS_BOUNCE, e = Tween.EASE_IN_OUT, backward = false) -> void:
	if backward:
		tween.interpolate_property(n , p, val2, val1, d, t, e)
	else:
		tween.interpolate_property(n , p, val1, val2, d, t, e)
	tween.start()

func _ready() -> void:
	close_animation(true)
	
	$Header/Title.text = modal_name
	if !can_close:
		$Header/CloseButton.visible = false


var drag_zone_hovered := false

var dragged := false
var base_drag_position := Vector2()

var i = 0.0
func _process(delta: float) -> void:
	i += delta * 2.0
	var _m = get_global_mouse_position()
	if drag_zone_hovered:
		if Input.is_action_just_pressed("drag"):
			get_parent().move_child(self, get_parent().get_child_count())
			dragged = true
			rect_pivot_offset = _m - rect_position
			base_drag_position = _m - rect_position
			play_tween(self, "rect_scale", rect_scale, Vector2.ONE * 1.25, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			play_tween($Shadow, "modulate:a", $Shadow.modulate.a, 1.0, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)

			i = 0.0
	if dragged && Input.is_action_just_released("drag"):
		play_tween(self, "rect_scale", rect_scale, Vector2.ONE, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		play_tween($Shadow, "modulate:a", $Shadow.modulate.a, 0.0, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)

		rect_rotation = 0.0
		dragged = false
	if dragged:
		rect_rotation = sin(i) * 10.0
		
		if _m.x > 0 && _m.y > 0 && _m.x < get_viewport().size.x && _m.y < get_viewport().size.y:
			rect_position = lerp(rect_position, _m - base_drag_position, delta * 5.0)


func _on_DragZone_mouse_entered() -> void:
	drag_zone_hovered = true


func _on_DragZone_mouse_exited() -> void:
	drag_zone_hovered = false


func _on_CloseButton_pressed() -> void:
	close_animation()

	rect_pivot_offset = get_global_mouse_position() - rect_position
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func close_animation(backward = false) -> void:
	play_tween(self, "rect_scale", rect_scale, Vector2.ZERO, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)
	play_tween(self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)
	play_tween(self, "rect_rotation", 0, -30 if randi() % 2 == 0 else 30, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)
