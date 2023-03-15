extends Area

# Config
export(int, 1, 2) var line := 1
export var max_stop_time := 10.0
export var max_speed := 20.0
export var part_count := 4
export var move_scale := 1.0
export var current_stop_id := 2
export var going_forward := true
export var stop_distance := 10

export(Resource) var subway_mesh


onready var next_stop_position := 30.0
onready var player: KinematicBody = $"../Player"
onready var c_stop_time := max_stop_time
onready var offset : float = 0.0
#onready var offset : float = get_offset() - (50.0 if going_forward else -50.0)

var stopped := false
var door_opened := false
var player_inside := false
var speed := 0.0


const STOPS := {
	1: {
		"cite_scientifique": 30,
		"pont_de_bois": 135,
		"beaux_arts": 457,
		"porte_des_postes": 554,
	},
	2: {
		"st_philibert": 0,
		"porte_des_postes": 370,
	},
}

#
#func get_offset() -> float:
#	return STOPS[line].values()[clamp(current_stop_id, 0, STOPS[line].size())]
#

var next_stop_id := 0

func _ready() -> void:
	next_stop_id = current_stop_id
	if going_forward:
		current_stop_id -= 1
	else:
		current_stop_id += 1
	
	for i in part_count:
		var _mesh = subway_mesh.instance()
		if i != 0:
			_mesh.get_node("FrontWall").queue_free()
		else:
			_mesh.get_node("FrontSeparation").queue_free()
		if i != part_count - 1:
			_mesh.get_node("BackWall").queue_free()
		else:
			_mesh.get_node("BackSeparation").queue_free()
		_mesh.translation.z = i * 14.4 - 14.4 * 2 + 7.2
		$Parts.add_child(_mesh)
	
	var _start_offset = -50.0
	translation.z = (_start_offset if going_forward else -_start_offset) * 1.0 / move_scale
	if going_forward:
		offset = STOPS[line].values()[next_stop_id] + _start_offset
	else:
		offset = STOPS[line].values()[next_stop_id] - _start_offset
	next_stop_position = STOPS[line].values()[next_stop_id]


var looped_once := true


export var acceleration := 5.0
export var decceleration := 0.98

onready var station := get_parent().get_node("Station")

func fdsfdsfges() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	looped_once = false

func _process(delta: float) -> void:
	if speed > 0.0:
		$Engine.pitch_scale = speed / max_speed
	if offset > next_stop_position - stop_distance && going_forward || offset < next_stop_position + stop_distance && !going_forward:
		speed *= 0.98
	elif speed < max_speed:
		speed += delta * acceleration
	var _dis1 = 0
	var _dis2 = 0
	if current_stop_id == -1:
		_dis1 = 0
		_dis2 = STOPS[line].values()[1]
	elif current_stop_id == 4:
		_dis1 = STOPS[line].values()[3]
		_dis2 = STOPS[line].values()[2]
	else:
		if going_forward:
			_dis1 = STOPS[line].values()[current_stop_id]
			_dis2 = STOPS[line].values()[next_stop_id]
		else:
			_dis1 = STOPS[line].values()[current_stop_id]
			_dis2 = STOPS[line].values()[next_stop_id]
	if offset >= next_stop_position && going_forward || offset <= next_stop_position && !going_forward:
		speed = 0.0
		translation.z = 2.0
		c_stop_time -= delta
		if !door_opened && c_stop_time > 0.0:
			interact_door(true)
			station.interact_door(true, !going_forward)
		if door_opened && c_stop_time <= 0.0:
			interact_door(false)
			station.interact_door(false, !going_forward)
		if c_stop_time <= -2.0:
			if is_at_terminus(next_stop_id):
				going_forward = !going_forward
				if !going_forward:
					current_stop_id += 2
				else:
					current_stop_id -= 2
			if going_forward:
				current_stop_id += 1
				next_stop_id += 1
			else:
				current_stop_id -= 1
				next_stop_id -= 1
			next_stop_position = STOPS[line].values()[next_stop_id]
			c_stop_time = max_stop_time
			fdsfdsfges()
	offset += delta * speed * (1 if going_forward else -1) * move_scale

	if going_forward:
		translation += -Vector3.FORWARD * speed * delta
	else:
		translation -= -Vector3.FORWARD * speed * delta
	
	if player_inside:
		$Engine.global_translation = player.translation
		if going_forward:
			player.translation += -Vector3.FORWARD * speed * delta
		else:
			player.translation -= -Vector3.FORWARD * speed * delta
	var distance_between := abs(_dis1 - _dis2)
	if going_forward && abs(offset - _dis2) < distance_between / 2.0 && !looped_once || !going_forward && !(abs(offset - _dis2) > distance_between / 2.0) && !looped_once:
		station.station_changed(next_stop_id)
		var _diff = -translation.z
		translation.z = _diff
		if player_inside:
			player.translation.z += _diff * 2.0
		looped_once = true


func is_at_terminus(stop_id : int) -> bool:
	return stop_id == 0 && !going_forward || stop_id == STOPS[line].size() - 1 && going_forward



func stop_id_to_string(stop_id : int) -> String:
	return STOPS[line].keys()[stop_id]


func interact_door(open : bool) -> void:
	if open:
		for i in $Parts.get_children():
			i.close_door()
			$Tween.interpolate_property(i.get_node("DoorL"), "translation:z", 4, 4.7, 1.5, Tween.TRANS_BOUNCE)
			$Tween.interpolate_property(i.get_node("DoorR"), "translation:z", 3.2, 2.5, 1.5, Tween.TRANS_BOUNCE)
			$Tween.start()
	else:
		for i in $Parts.get_children():
			i.close_door()
			$Tween.interpolate_property(i.get_node("DoorL"), "translation:z", 4.7, 4, 1.5, Tween.TRANS_BOUNCE)
			$Tween.interpolate_property(i.get_node("DoorR"), "translation:z", 2.5, 3.2, 1.5, Tween.TRANS_BOUNCE)
			$Tween.start()
	door_opened = open


func _on_MovingSubway_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_inside = true

func _on_MovingSubway_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false


func _on_Occluder_camera_entered(camera: Camera) -> void:
	print("coucou la caméra ")

func _on_Occluder_camera_exited(camera: Camera) -> void:
	print("aurevoir la caméra :(")
	pass # Replace with function body.
