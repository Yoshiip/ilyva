extends Area

# Config
export(int, 1, 2) var line := 1
export var max_stop_time := 10.0
export var max_speed := 20.0
export var part_count := 4

export var going_forward := true

export var current_stop_id := 2



onready var c_stop_time := max_stop_time

onready var speed := 0.0

onready var offset : float = get_offset() - 50.0

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



export(Resource) var subway_mesh

onready var next_stop_position := get_offset() 


func get_offset() -> float:
	return STOPS[line].values()[clamp(current_stop_id, 0, STOPS[line].size())]

func _ready() -> void:
	translation.z = -50
	next_stop_position = STOPS[line][stop_id_to_string(current_stop_id)]
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

func get_next_stop() -> String:
	if going_forward:
		if current_stop_id == STOPS[line].size() - 1:
			return stop_id_to_string(current_stop_id)
		return STOPS[line].keys()[current_stop_id + 1]
	else:
		if current_stop_id == 0:
			return stop_id_to_string(current_stop_id)
	return STOPS[line].keys()[current_stop_id - 1]


func stop_id_to_string(stop_id : int) -> String:
	return STOPS[line].keys()[stop_id]



func get_distance_between_stops(stop_1 : String, stop_2 : String) -> float:
	return abs(STOPS[line][stop_1] - STOPS[line][stop_2])
#	if current_stop_id == 0 && !going_forward || current_stop_id == STOPS[line].size() && going_forward:
#		return 0.0 # terminus
#	else:
#		if going_forward:
#			return STOPS[line].values()[current_stop_id + 1] - STOPS[line].values()[current_stop_id]
#		else:
#			return STOPS[line].values()[current_stop_id] - STOPS[line].values()[current_stop_id - 1]

func change_stop_index() -> void:

	if current_stop_id == 0:
		going_forward = true
	if current_stop_id == STOPS[line].size() - 1:
		going_forward = false
	current_stop_id += 1 if going_forward else -1

	next_stop_position = STOPS[line][stop_id_to_string(current_stop_id)]


var stopped := false

func _process(delta: float) -> void:
	

	
	if speed > 0.0:
		$Engine.pitch_scale = speed / max_speed
	

	
	if !stopped:
		if going_forward && offset > next_stop_position - 8 || !going_forward && offset < next_stop_position + 8:
			speed *= 0.98
		else:
			speed = clamp(speed + delta * 5.0, 0, max_speed)
	
	if going_forward && offset >= next_stop_position && speed <= 0.05 || !going_forward && offset <= next_stop_position && speed <= 0.05:
		speed = 0.0
		c_stop_time -= delta
		if !opened && c_stop_time >= 0.0:
			interact_door(true)
			stopped = true
			$Engine.stop()
		if opened && c_stop_time <= 0.0:
			change_stop_index()
			interact_door(false)
			stopped = false
			$Engine.play()
			c_stop_time = max_stop_time
#		if !opened && c_stop_time < max_stop_time - 2 && c_stop_time > 0:
#			interact_door(true)
#			stopped = true
#		if c_stop_time <= 0.0:
#			
#			interact_door(false)
#		if c_stop_time <= -2.0: # start
#			stopped = false
#			c_stop_time = max_stop_time

	if going_forward:
		translation += -Vector3.FORWARD * speed * delta
		offset += speed * delta
	else:
		translation -= -Vector3.FORWARD * speed * delta
		offset -= speed * delta

	if current_stop_id != -1:
		var distance_between := get_distance_between_stops(stop_id_to_string(current_stop_id), get_next_stop())

		if translation.z > (distance_between - 27) / 2.0:
			var _o = (distance_between)
			translation.z -= _o
			if player_inside:
				player.translation.z -= _o
	if player_inside:
		$Engine.global_translation = player.translation
		if going_forward:
			player.translation += -Vector3.FORWARD * speed * delta
		else:
			player.translation -= -Vector3.FORWARD * speed * delta


var opened := false

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
	opened = open
	
onready var player: KinematicBody = $"../Player"


var player_inside = false

func _on_MovingSubway_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_inside = true

func _on_MovingSubway_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false
