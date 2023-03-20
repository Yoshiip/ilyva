extends Spatial

var left_doors_opened := false
var right_doors_opened := false


func interact_door(open, left = true) -> void:
	var _door1 = $station.get_node(str("Door", "L" if left else "R", "L"))
	var _door2 = $station.get_node(str("Door", "L" if left else "R", "R"))
	if open:
		$Tween.interpolate_property(_door1, "translation:z", 27.2, 27.9, 1.5, Tween.TRANS_BOUNCE)
		$Tween.interpolate_property(_door2, "translation:z", 27.2, 26.5, 1.5, Tween.TRANS_BOUNCE)
	else:
		$Tween.interpolate_property(_door1, "translation:z", 27.2, 27.9, 1.5, Tween.TRANS_BOUNCE)
		$Tween.interpolate_property(_door2, "translation:z", 27.2, 26.5, 1.5, Tween.TRANS_BOUNCE)
	$Tween.start()
	if left:
		left_doors_opened = open
	else:
		right_doors_opened = open



export var current_station := 0

var stations_names := {
	0: "Cité Scientifique\nPf. Bastvm",
	1: "Pont de Bois",
	2: "Beaux Arts",
	3: "Porte des Postes",
}

func station_changed(new_station : int) -> void:
	current_station = new_station
	for i in $Labels.get_children():
		i.text = stations_names[new_station]
