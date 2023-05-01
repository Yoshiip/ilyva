extends Control


onready var tween := Tween.new()


const STATIONS := [
	{
		"name": "Cité Scientifique\nPf. Bastvm",
		"scene": "res://scenes/IUT/Station.tscn",
		"line": 1,
		"voice": preload("res://extra/voices/subway/cite_scientifique.mp3"),
	},
	{
		"name": "Pont de Bois",
		"scene": "res://scenes/PontDeBois/Station.tscn",
		"voice": preload("res://extra/voices/subway/pont_de_bois.mp3"),
		"line": 1,
	},
	{
		"name": "République\nBeaux-Arts",
		"scene": "res://scenes/BeauxArts/Station.tscn",
		"voice": preload("res://extra/voices/subway/beaux_arts.mp3"),
		"line": 1,
	},
	{
		"name": "Saint-Philibert",
		"scene": "res://scenes/StPhilibert/Station.tscn",
		"voice": preload("res://extra/voices/subway/saint_philibert.mp3"),
		"line": 2,
	},
]


onready var current_station = GameManager.current_subway_stop
onready var transition := preload("res://prefabs/Transition.tscn").instance()

onready var subway_transition: ColorRect = $Canvas/Container/SubwayTransition
onready var station_name: Label = $Canvas/Container/Content/StationName


func _ready() -> void:
	MusicManager.start_music("subway")
	add_child(transition)
	update_station_name()
#	transition.transition_to_scene(STATIONS[$Station.current_station].scene)
	add_child(tween)
	

func update_station_name() -> void:
	station_name.text = STATIONS[current_station].name
	station_name.add_color_override("font_color", Color("fdc422") if STATIONS[current_station].line == 1 else Color("de0815"))
	station_name.add_color_override("font_outline_modulate", Color("fdc422") if STATIONS[current_station].line == 1 else Color("de0815"))
	
	
	var _station : int = current_station + offset
	$Canvas/Container/Content/Left/TravelLeft.visible = current_station != 3
	$Canvas/Container/Content/Right/TravelRight.visible = current_station != 0
	if !GameManager.unlocked_levels.has(current_station):
		$Canvas/Container/Content/Left/TravelLeft.visible = false
		$Canvas/Container/Content/Right/TravelRight.visible = false
		yield($Voice, "finished")
		var new_dialog = Dialogic.start(str("subway/", current_station))
		get_tree().current_scene.add_child(new_dialog)

var offset := 0

func travel(new_offset : int) -> void:
	var _temp
	self.offset = new_offset
	subway_transition.visible = true
	_temp = tween.interpolate_property(subway_transition, "modulate:a", 0.0, 1.0, 0.5)
	_temp = tween.interpolate_property($SubwayEngine, "volume_db", -80, -20, 0.5)
	_temp = tween.start()
	$SubwayEngine.play()
	yield(get_tree().create_timer(3.0), "timeout")
	current_station += offset
	$Voice.stream = STATIONS[current_station].voice
	$Voice.play()
	update_station_name()
	_temp = tween.interpolate_property(subway_transition, "modulate:a", 1.0, 0.0, 0.5)
	_temp = tween.interpolate_property($SubwayEngine, "volume_db", -20, -80, 0.5)
	_temp = tween.start()
	yield(get_tree().create_timer(0.5), "timeout")
	subway_transition.visible = false


func _on_TravelLeft_pressed() -> void:
	travel(1)


func _on_TravelRight_pressed() -> void:
	travel(-1)


func _on_Button_pressed() -> void:
	GameManager.current_subway_stop = current_station
	GameManager.save()
	transition.transition_to_scene(STATIONS[current_station].scene)
