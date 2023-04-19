extends Spatial

# Config
export var max_stop_time := 10.0
export var max_speed := 20.0
export var move_scale := 1.0
export var going_forward := true
export var stop_distance := 20

onready var next_stop_position := 30.0
onready var player: KinematicBody = $"../Player"
onready var c_stop_time := max_stop_time
onready var offset : float = 0.0
#onready var offset : float = get_offset() - (50.0 if going_forward else -50.0)

var block_door_closing = false
var current_stop_id := 0

var stopped := false

var door_opened := false
var door_moving := false

var player_inside := false
onready var speed := max_speed

const AUDIOS := [
	preload("res://audios/voices/subway/0.ogg"),
	preload("res://audios/voices/subway/1.ogg"),
	preload("res://audios/voices/subway/2.ogg"),
	preload("res://audios/voices/subway/3.ogg"),
	preload("res://audios/voices/subway/4.ogg"),
]


var next_stop_id := 0


func _ready() -> void:
	update_line_used(true)
	next_stop_id = current_stop_id
	if going_forward:
		current_stop_id -= 1
	else:
		current_stop_id += 1
	var _SubwayPart := preload("res://prefabs/3d/SubwayPart.tscn")
	for i in 4:
		var _mesh = _SubwayPart.instance()
		if i != 0:
			_mesh.get_node("FrontWall").queue_free()
		else:
			_mesh.get_node("FrontSeparation").queue_free()
		if i != 3:
			_mesh.get_node("BackWall").queue_free()
		else:
			_mesh.get_node("BackSeparation").queue_free()
		_mesh.translation.z = i * 14.4 - 14.4 * 2 + 7.2
		$Parts.add_child(_mesh)
	
	var _start_offset = -50.0
	translation.z = (_start_offset if going_forward else -_start_offset) * 1.0 / move_scale
	if going_forward:
		offset = GameManager.STATIONS[next_stop_id].offset + _start_offset
	else:
		offset = GameManager.STATIONS[next_stop_id].offset - _start_offset
	next_stop_position = GameManager.STATIONS[next_stop_id].offset


var looped_once := true


export var acceleration := 5.0
export var decceleration := 0.98

onready var station := get_parent().get_node("Station")

func fdsfdsfges() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	looped_once = false
	
var translation_offset : Vector3

var start_playing_beep := false

func _process(delta: float) -> void:
	if speed > 0.0:
		if !$Effects/Engine.playing:
			$Effects/Engine.play()
		$Effects/Engine.pitch_scale = speed / max_speed
	else:
		$Effects/Engine.stop()
	if offset > next_stop_position - stop_distance && going_forward || offset < next_stop_position + stop_distance && !going_forward:
		speed *= decceleration
	elif speed < max_speed:
		speed += delta * acceleration
	var _dis1 = 0
	var _dis2 = 0
	if current_stop_id == -1:
		_dis1 = 0
		_dis2 = GameManager.STATIONS[1].offset
	elif current_stop_id == 5:
		_dis1 = GameManager.STATIONS[4].offset
		_dis2 = GameManager.STATIONS[3].offset
	else:
#		if going_forward:
		_dis1 = GameManager.STATIONS[current_stop_id].offset
		_dis2 = GameManager.STATIONS[next_stop_id].offset
#		else:
#			_dis1 = GameManager.STATIONS[current_stop_id]
#			_dis2 = GameManager.STATIONS[next_stop_id]
#	print(str(GameManager.map_stop_progress, " > ", next_stop_id))
	if offset >= next_stop_position && going_forward|| offset <= next_stop_position && !going_forward:
		speed = 0.0
		translation.z = 2.0
		c_stop_time -= delta
		if !door_opened && c_stop_time > 0.0:
			if player_inside:
				get_tree().current_scene.play_zone_animation(GameManager.STATIONS[next_stop_id].name)
				$Effects/Voice.stream = AUDIOS[next_stop_id]
				$Effects/Voice.play()
			start_playing_beep = false
			interact_door(true, !going_forward)
			yield(get_tree().create_timer(0.5), "timeout")
			station.interact_door(true, !going_forward)

#		if door_opened && c_stop_time <= 0.0 && !start_playing_beep && !(GameManager.map_stop_progress == next_stop_id):
		if door_opened && c_stop_time <= 0.0 && !start_playing_beep:
			start_playing_beep = true
			$Effects/DoorBeep.play()
		if door_moving && block_door_closing:
			start_playing_beep = false
			$Tween.stop_all()
			interact_door(true, !going_forward)
			station.interact_door(true, !going_forward)
		if c_stop_time <= -2.0 && !door_opened && !door_moving:
			if is_at_terminus(next_stop_id):
				translation.x = -translation.x
				update_line_used(false)
				going_forward = !going_forward
				update_line_used(true)
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
			next_stop_position = GameManager.STATIONS[next_stop_id].offset
			c_stop_time = max_stop_time
			fdsfdsfges()
	offset += delta * speed * (1.0 if going_forward else -1.0) * move_scale

	if going_forward:
		translation += -Vector3.FORWARD * speed * delta
	else:
		translation -= -Vector3.FORWARD * speed * delta
	var distance_between := abs(_dis1 - _dis2)
	
	
	if going_forward && abs(offset - _dis2) < distance_between / 2.0 && !looped_once || !going_forward && !(abs(offset - _dis2) > distance_between / 2.0) && !looped_once:
		var _diff = -translation.z
		translation.z = _diff
		if player_inside:
			station.station_changed(next_stop_id)
		else:
			update_line_used(false)
			queue_free()
		looped_once = true
	if player_inside:
		$Effects.global_translation = player.translation
		player.translation += translation - translation_offset
		translation_offset = translation


func is_at_terminus(stop_id : int) -> bool:
	return stop_id == 0 && !going_forward || stop_id == GameManager.STATIONS.size() - 1 && going_forward

func update_line_used(value : bool) -> void:
	if going_forward:
		get_tree().current_scene.set("right_line_used", value)
	else:
		get_tree().current_scene.set("left_line_used", value)



func interact_door(open : bool, left : bool) -> void:
	door_moving = true
	$Effects/DoorClose.play()
	if open:
		for i in $Parts.get_children():
			var _door1 = i.get_node(str("Door", "R" if left else "L", "L"))
			var _door2 = i.get_node(str("Door", "R" if left else "L", "R"))
			$Tween.interpolate_property(_door1, "translation:z", _door1.translation.z, 4.7, 1.5, Tween.TRANS_BOUNCE)
			$Tween.interpolate_property(_door2, "translation:z", _door2.translation.z, 2.5, 1.5, Tween.TRANS_BOUNCE)
			$Tween.start()
	else:
		for i in $Parts.get_children():
			var _door1 = i.get_node(str("Door", "R" if left else "L", "L"))
			var _door2 = i.get_node(str("Door", "R" if left else "L", "R"))
			$Tween.interpolate_property(_door1, "translation:z", _door1.translation.z, 4, 1.5, Tween.TRANS_BOUNCE)
			$Tween.interpolate_property(_door2, "translation:z", _door2.translation.z, 3.2, 1.5, Tween.TRANS_BOUNCE)
			$Tween.start()
	door_opened = open
	yield(get_tree().create_timer(1.5), "timeout")
	door_moving = false



func _on_AreaZone_body_entered(body: Node) -> void:
	if body.name == "Player":
		translation_offset = global_translation
		get_tree().current_scene._player_entered_subway(self)
		player_inside = true
		body.current_subway = self


func _on_AreaZone_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false
		get_tree().current_scene._player_exited_subway(self)
		body.current_subway = null


func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		block_door_closing = true


func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		block_door_closing = false


func _on_DoorBeep_finished() -> void:
	if !block_door_closing:
		interact_door(false, !going_forward)
		yield(get_tree().create_timer(0.5), "timeout")
		station.interact_door(false, !going_forward)
	else:
		$Effects/DoorBeep.play()
