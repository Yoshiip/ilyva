extends Area2D

onready var tween := Tween.new()

export var character_name := ""
export(int, "Dialogue", "Action", "No icon") var icon_type
export var one_time_interact := false


export(StreamTexture) var portrait : StreamTexture
export var timeline_id := 0

export var sprite_scale := 1.0
export(int, 0, 99) var min_story_progress := 0
export(int, -1, 99) var max_story_progress := 0


var last_timeline_spoke := -1


func _ready() -> void:
	can_interact = GameManager.progress[get_tree().current_scene.zone_id][name if character_name == "" else character_name] >= min_story_progress
	if icon_type == 1:
		$Icon.texture = preload("res://images/icons/exclamation_icon.png")
	elif icon_type == 3:
		$Icon.queue_free()
	if name in GameManager.one_time_interacts:
		queue_free()

	if character_name == "":
		character_name = name
	progress_changed()
	
	$Sprite.scale = Vector2.ONE * sprite_scale
	if name == "Arrow":
		$Sprite.scale.x *= 2.0
	$Sprite.texture = portrait
	$Collision.shape = $Collision.shape.duplicate()
	$Collision.shape.extents = portrait.get_size() * sprite_scale * 0.5
	$Icon.position.y = -(portrait.get_size().y * sprite_scale) + 64
	add_child(tween)

var i = 0.0



func _process(delta: float) -> void:
	if is_instance_valid($Icon):
		i += delta * 90.0
		if i > 90:
			i -= 180
		$Icon.visible = last_timeline_spoke != timeline_id
		$Icon.material.set_shader_param("y_rot", i)

func interact() -> void:
	get_tree().current_scene.current_dialogue_character = self
	get_tree().current_scene.current_dialogue_id = timeline_id
	if one_time_interact:
		get_tree().current_scene.create_dialogue(str(get_tree().current_scene.zone_id, "/" + character_name +"/0"))
	else:
		get_tree().current_scene.create_dialogue(str(get_tree().current_scene.zone_id, "/" + character_name +"/", timeline_id))
	last_timeline_spoke = timeline_id
	if one_time_interact:
		GameManager.one_time_interacts.append(name)
		queue_free()

func turn_light(on : bool) -> void:
	if on:
		var _temp := tween.interpolate_property($Light, "energy", 0.0, 1.0, 0.5, Tween.TRANS_EXPO)
	else:
		var _temp := tween.interpolate_property($Light, "energy", 1.0, 0.0, 0.5, Tween.TRANS_EXPO)
	var _temp := tween.start()

onready var can_interact : bool

func progress_changed() -> void:
	var _sp = GameManager.progress[get_tree().current_scene.zone_id][character_name]
	
	timeline_id = _sp
	
	$Collision.disabled = !(_sp >= min_story_progress)
	visible = _sp >= min_story_progress
	if _sp >= max_story_progress && max_story_progress != -1:
		queue_free()
