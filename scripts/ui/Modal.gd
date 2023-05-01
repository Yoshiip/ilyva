extends Panel

var pinned := false
var old_margin : Rect2
export var app_id := ""
export var can_close := true
export var can_pin := true
export var can_maximize := true
export var can_drag := true
export var min_size := Vector2(128, 128)
var maximize := false
onready var tween := $Tween
var puzzle : Puzzle
var icon_offset := 0

var drag_zone_hovered := false

var dragging := false
var resizing := false

var base_action_position := Vector2()
var base_action_size := Vector2()

const TASKBAR_SIZE := 40

var i = 0.0


func play_tween(n : Node, p : String, val1, val2, d : float, t = Tween.TRANS_BOUNCE, e = Tween.EASE_IN_OUT, backward = false) -> void:
	if backward:
		tween.interpolate_property(n , p, val2, val1, d, t, e)
	else:
		tween.interpolate_property(n , p, val1, val2, d, t, e)
	tween.start()




func _ready() -> void:
	close_animation(true)
	name = app_id
	$Header/Buttons/Pin.pressed = pinned
	$Header/Icon.texture = $Header/Icon.texture.duplicate()
	if app_id != "":
		$Header/Icon.texture.region.position.y = GameManager.APPS[app_id].icon * 16.0
	$DragZone.mouse_default_cursor_shape = Control.CURSOR_MOVE if can_drag else Control.CURSOR_ARROW
	$Header/Title.text = app_id + ".sh"
	$Header/DragHint.visible = can_drag
	$Header/Buttons/Close.visible = can_close
	$Header/Buttons/Maximize.visible = can_maximize
	$Header/Buttons/Pin.visible = can_pin

func _process(delta: float) -> void:
	i += delta * 2.0
	
	var _m := get_global_mouse_position()
	$Header/Icon.texture.region.position.x = 16 if _m.x > rect_position.x && _m.y > rect_position.y && _m.x < rect_position.x + rect_size.x && _m.y < rect_position.y + rect_size.y else 0
	
	if resizing:
		var _new_size = (_m - base_action_position)
		rect_size.x = clamp(_new_size.x, min_size.x, get_viewport().size.x)
		rect_size.y = clamp(_new_size.y, min_size.y, get_viewport().size.y - TASKBAR_SIZE)
		if Input.is_action_just_released("mouse_left"):
			resizing = false
	elif drag_zone_hovered && !maximize && can_drag:
		if Input.is_action_just_pressed("mouse_left"):
			get_parent().move_modal(self)
			dragging = true
			rect_pivot_offset = _m - rect_position
			base_action_position = _m - rect_position
			play_tween(self, "rect_scale", rect_scale, Vector2.ONE * 1.25, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			play_tween($Shadow, "modulate:a", $Shadow.modulate.a, 1.0, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)

			i = 0.0
	if dragging && Input.is_action_just_released("mouse_left") && !resizing:
		tween.remove_all()
		play_tween(self, "rect_scale", rect_scale, Vector2.ONE, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		play_tween($Shadow, "modulate:a", $Shadow.modulate.a, 0.0, 0.25, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)

		rect_rotation = 0.0
		dragging = false
	if dragging && !resizing:
		rect_rotation = sin(i) * 10.0
		

		rect_position.x = clamp(lerp(rect_position.x, _m.x - base_action_position.x, delta * 20.0), 0, get_viewport().size.x - rect_size.x)
		rect_position.y = clamp(lerp(rect_position.y, _m.y - base_action_position.y, delta * 20.0), 0, get_viewport().size.y - TASKBAR_SIZE - rect_size.y)


func _on_DragZone_mouse_entered() -> void:
	drag_zone_hovered = true


func _on_DragZone_mouse_exited() -> void:
	drag_zone_hovered = false


func close() -> void:
	close_animation()

	rect_pivot_offset = get_global_mouse_position() - rect_position
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func _on_CloseButton_pressed() -> void:
	close()

func close_animation(backward = false) -> void:
	play_tween(self, "rect_scale", rect_scale, Vector2.ZERO, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)
	play_tween(self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)
	play_tween(self, "rect_rotation", 0, -30 if randi() % 2 == 0 else 30, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, backward)






func _on_PinButton_pressed() -> void:
	pinned = !pinned


func _on_Maximize_pressed() -> void:
	maximize = !maximize
	if !maximize:
		play_tween(self, "anchor_right", 1.0, 0.0, 0.5)
		play_tween(self, "anchor_bottom", 1.0, 0.0, 0.5)
		play_tween(self, "rect_position", rect_position, old_margin.position, 0.5)
		play_tween(self, "rect_size", rect_size, old_margin.size, 0.5)
		
	else:
		old_margin.position = rect_position
		old_margin.size = rect_size
		
		
		
		rect_position = Vector2.ZERO
		rect_size = Vector2.ZERO
		
		play_tween(self, "anchor_right", 0.0, 1.0, 0.5)
		play_tween(self, "anchor_bottom", 0.0, 1.0, 0.5)
		margin_bottom = -40




func _on_Resize_pressed() -> void:
	base_action_position = rect_position
	base_action_size = rect_size
	resizing = true
