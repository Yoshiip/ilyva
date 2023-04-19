extends Control


onready var tween := Tween.new()


var current_station = 4
onready var transition := preload("res://prefabs/Transition.tscn").instance()

func _ready() -> void:
	$Canvas/Container.add_child(transition)
	update_station_name()
#	transition.transition_to_scene(GameManager.STATIONS[$Station.current_station].scene)
	add_child(tween)
	
onready var subway_transition: ColorRect = $Canvas/Container/SubwayTransition

onready var station_name: Label = $Canvas/Container/Content/StationName

func update_station_name() -> void:
	station_name.text = GameManager.STATIONS[current_station].name
	station_name.add_color_override("font_color", Color("fdc422") if GameManager.STATIONS[current_station].line == 1 else Color("de0815"))
	station_name.add_color_override("font_outline_modulate", Color("fdc422") if GameManager.STATIONS[current_station].line == 1 else Color("de0815"))
	

	if current_station == 4:
		$Canvas/Container/Content/Left/TravelLeft.visible = false
	else:
		$Canvas/Container/Content/Left/TravelLeft.visible = true
	print(str("subway/", GameManager.STATIONS[current_station].map_progress))
	if GameManager.map_stop_progress > GameManager.STATIONS[current_station].map_progress:
		var new_dialog = Dialogic.start(str("subway/", current_station))
		get_tree().current_scene.add_child(new_dialog)
		$Canvas/Container/Content/Right/TravelRight.visible = false
	else:
		if current_station == 0:
			$Canvas/Container/Content/Right/TravelRight.visible = false
		else:
			$Canvas/Container/Content/Right/TravelRight.visible = true

func travel(offset : int) -> void:
	subway_transition.visible = true
	tween.interpolate_property(subway_transition, "modulate:a", 0.0, 1.0, 0.5)
	tween.interpolate_property($SubwayEngine, "volume_db", -80, -20, 0.5)
	tween.start()
	$SubwayEngine.play()
	yield(get_tree().create_timer(3.0), "timeout")
	current_station += offset
	update_station_name()
	tween.interpolate_property(subway_transition, "modulate:a", 1.0, 0.0, 0.5)
	tween.interpolate_property($SubwayEngine, "volume_db", -20, -80, 0.5)
	tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	subway_transition.visible = false

func _on_TravelLeft_pressed() -> void:
	travel(1)

	


func _on_TravelRight_pressed() -> void:
	travel(-1)


func _on_Button_pressed() -> void:
	transition.transition_to_scene(GameManager.STATIONS[current_station].scene)
