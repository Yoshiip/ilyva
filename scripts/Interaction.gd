extends Area2D

onready var tween := Tween.new()

export var character_name := ""
export var timeline_id := 0


var last_timeline_spoke := -1


func _ready() -> void:
	add_child(tween)
	if character_name == "":
		character_name = name

var i = 0.0

func _process(delta: float) -> void:
	$Icon.visible = last_timeline_spoke != timeline_id
	i += delta * 90.0
	if i > 90:
		i -= 180
	$Icon.material.set_shader_param("y_rot", i)

func interact() -> void:
	var new_dialog = Dialogic.start(str(get_tree().current_scene.zone_id, "/" + character_name +"/", timeline_id))
	get_tree().current_scene.add_child(new_dialog)
	last_timeline_spoke = timeline_id

func turn_light(on : bool) -> void:
	if on:
		tween.interpolate_property($Light, "energy", 0.0, 1.0, 0.5, Tween.TRANS_EXPO)
	else:
		tween.interpolate_property($Light, "energy", 1.0, 0.0, 0.5, Tween.TRANS_EXPO)
	tween.start()
