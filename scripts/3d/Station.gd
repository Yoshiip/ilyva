extends Spatial

var left_doors_opened := false
var right_doors_opened := false

func _ready() -> void:
	station_changed(current_station)


func interact_door(open, left = true) -> void:
	var _door1 = $station.get_node(str("Door", "L" if left else "R", "L"))
	var _door2 = $station.get_node(str("Door", "L" if left else "R", "R"))
	if open:
		$Tween.interpolate_property(_door1, "translation:z", _door1.translation.z, 28 if !left else 26.4, 1.5, Tween.TRANS_BOUNCE)
		$Tween.interpolate_property(_door2, "translation:z", _door2.translation.z, 26.4 if !left else 28, 1.5, Tween.TRANS_BOUNCE)
	else:
		$Tween.interpolate_property(_door2, "translation:z", _door1.translation.z, 27.2, 1.5, Tween.TRANS_BOUNCE)
		$Tween.interpolate_property(_door1, "translation:z", _door2.translation.z, 27.2, 1.5, Tween.TRANS_BOUNCE)
	$Tween.start()
	if left:
		left_doors_opened = open
	else:
		right_doors_opened = open


export var current_station := 0


onready var Barrier := preload("res://prefabs/3d/Barrier.tscn")
onready var Sign := preload("res://prefabs/3d/Sign.tscn")

func station_changed(new_station : int) -> void:
	current_station = new_station
	for i in $Temp.get_children():
		i.queue_free()
	for i in $Labels.get_children():
		i.text = GameManager.STATIONS[new_station].name
	
	
	var _index = new_station
	
	if _index == 0:
		create_barrier(-6.5)
	else:
		create_sign(-6.5, GameManager.STATIONS[0].name)

	if _index == GameManager.STATIONS.size() - 1:
		create_barrier(6.5)
	else:
		create_sign(6.5, GameManager.STATIONS[GameManager.STATIONS.size() - 1].name)

func create_barrier(x : float) -> void:
	var _barrier := Barrier.instance()
	_barrier.translation.x = x
	$Temp.add_child(_barrier)

func create_sign(x : float, text : String) -> void:
	var _sign := Sign.instance()
	_sign.translation.x = x
	_sign.get_node("Text/TerminusName").text =  text
	if text == GameManager.STATIONS[4].name: # saint philibert
		_sign.get_node("Mesh").material = _sign.get_node("Mesh").material.duplicate()
		_sign.get_node("Mesh").material.albedo_color = Color("de0815")
		_sign.get_node("Text/LineNumber").text = "2" 
	else:
		_sign.get_node("Text/LineNumber").text = "1" 
	$Temp.add_child(_sign)


func _on_TravelArea_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().current_scene.can_travel = true

func _on_TravelArea_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		get_tree().current_scene.can_travel = false
