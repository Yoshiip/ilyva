extends Area

export var max_stop_time := 10.0
var c_stop_time := 10.0

export var max_speed := 20.0
onready var speed := max_speed


export(Resource) var subway_mesh

var next_stop_position := 0

export var part_count := 4

func _ready() -> void:
	for i in part_count:
		var _mesh = subway_mesh.instance()
		if i != 0:
			_mesh.get_node("FrontWall").queue_free()
		if i != part_count - 1:
			_mesh.get_node("BackWall").queue_free()
		_mesh.translation.z = i * 12.8 - 12.8 * 2
		$Parts.add_child(_mesh)


func _process(delta: float) -> void:
	
	$Engine.pitch_scale = speed / max_speed
	
	if translation.z > next_stop_position - 8:
		speed *= 0.98
	else:
		speed = clamp(speed + delta * 5.0, 0, max_speed)
	if translation.z > next_stop_position:
		if !opened && c_stop_time < max_stop_time - 2 && c_stop_time > 0:
			open_door()
		c_stop_time -= delta
		if opened && c_stop_time <= 0.0:
			open_door()
		if c_stop_time <= -2.0: # start
			next_stop_position += 1000
			c_stop_time = max_stop_time

	translation += -Vector3.FORWARD * speed * delta
	if translation.z > 256:
		translation.z -= 512
		if player_inside:
			player.translation.z -= 512
			next_stop_position = 0
	if player_inside:
		$Engine.global_translation = player.translation
		player.translation += -Vector3.FORWARD * speed * delta

var opened := false

func open_door() -> void:
	if !opened:
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
	opened = !opened
	
onready var player: KinematicBody = $"../Player"


var player_inside = false

func _on_MovingSubway_body_entered(body: Node) -> void:
	if body.name == "Player":
		player_inside = true

func _on_MovingSubway_body_exited(body: Node) -> void:
	if body.name == "Player":
		player_inside = false
