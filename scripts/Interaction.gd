extends Area2D

onready var tween := Tween.new()

export var character_name := ""
export(int, "Dialogue", "Action") var icon_type
export var one_time_interact := false


export(StreamTexture) var portrait : StreamTexture
export var timeline_id := 0

export var sprite_scale := 1.0
export(int, 0, 99) var min_story_progress := 0
export(int, -1, 99) var max_story_progress := 0


var last_timeline_spoke := -1


func _ready() -> void:
	if icon_type == 1:
		$Icon.texture = preload("res://images/icons/exclamation_icon.png")
	if name in GameManager.one_time_interacts:
		queue_free()
	get_parent().connect("story_progress_changed", self, "_story_progress_changed")
	_story_progress_changed()
	
	$Sprite.scale = Vector2.ONE * sprite_scale
	$Sprite.texture = portrait
	$Collision.shape.extents = (Vector2(portrait.get_size().x, portrait.get_size().y) / 2.0) * sprite_scale
	add_child(tween)
	if character_name == "":
		character_name = name

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
	var new_dialog = Dialogic.start(str(get_tree().current_scene.zone_id, "/" + character_name +"/", timeline_id))
	get_tree().current_scene.add_child(new_dialog)
	last_timeline_spoke = timeline_id
	if one_time_interact:
		GameManager.one_time_interacts.append(name)
		queue_free()

func turn_light(on : bool) -> void:
	if on:
		tween.interpolate_property($Light, "energy", 0.0, 1.0, 0.5, Tween.TRANS_EXPO)
	else:
		tween.interpolate_property($Light, "energy", 1.0, 0.0, 0.5, Tween.TRANS_EXPO)
	tween.start()

func _story_progress_changed() -> void:
	$Collision.disabled = !(GameManager.story_progress >= min_story_progress)
	visible = GameManager.story_progress >= min_story_progress
	if GameManager.story_progress >= max_story_progress && max_story_progress != -1:
		queue_free()
