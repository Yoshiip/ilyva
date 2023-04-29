extends Control


onready var tween := Tween.new()


const STATIONS := [
	{
		"name": "Cité Scientifique\nPf. Bastvm",
		"scene": "res://scenes/IUT/Station.tscn",
		"line": 1,
	},
	{
		"name": "Pont de Bois",
		"scene": "res://scenes/PontDeBois/Station.tscn",
		"line": 1,
	},
	{
		"name": "République\nBeaux-Arts",
		"scene": "res://scenes/BeauxArts/Entrance.tscn",
		"line": 1,
	},
	{
		"name": "Saint-Philibert",
		"scene": "res://scenes/StPhilibert/Station.tscn",
		"line": 2,
	},
]


onready var current_station = GameManager.current_subway_stop
onready var transition := preload("res://prefabs/Transition.tscn").instance()

func _ready() -> void:
	$Canvas/Container.add_child(transition)
	update_station_name()
#	transition.transition_to_scene(STATIONS[$Station.current_station].scene)
	add_child(tween)
	
onready var subway_transition: ColorRect = $Canvas/Container/SubwayTransition

onready var station_name: Label = $Canvas/Container/Content/StationName

func update_station_name() -> void:
	print(STATIONS[current_station])
	station_name.text = STATIONS[current_station].name
	station_name.add_color_override("font_color", Color("fdc422") if STATIONS[current_station].line == 1 else Color("de0815"))
	station_name.add_color_override("font_outline_modulate", Color("fdc422") if STATIONS[current_station].line == 1 else Color("de0815"))
	

	if current_station == 3:
		$Canvas/Container/Content/Left/TravelLeft.visible = false
	else:
		$Canvas/Container/Content/Left/TravelLeft.visible = true
	if !GameManager.unlocked_levels.has(current_station + offset):
		var new_dialog = Dialogic.start(str("subway/", current_station + offset))
		get_tree().current_scene.add_child(new_dialog)
		$Canvas/Container/Content/Right/TravelRight.visible = false
	else:
		if current_station == 0:
			$Canvas/Container/Content/Right/TravelRight.visible = false
		else:
			$Canvas/Container/Content/Right/TravelRight.visible = true

var offset := 0

func travel(offset : int) -> void:
	self.offset = offset
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
	GameManager.current_subway_stop = current_station
	transition.transition_to_scene(STATIONS[current_station].scene)
