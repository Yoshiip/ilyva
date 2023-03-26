extends Spatial

onready var map: ViewportContainer = $Canvas/Container/Minimap

var pause_menu

export var start_stop := 0
onready var transition := preload("res://prefabs/Transition.tscn").instance()


func _ready() -> void:
	$Canvas/Container.add_child(transition)
	$"%ZoneName".play_animation(GameManager.STATIONS[start_stop].name)
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	$Canvas/Container.add_child(pause_menu)

	for i in get_tree().get_nodes_in_group("Subway"):
		i.current_stop_id = start_stop
	
	map.visible = false
	
	settings_updated()
	GameManager.connect("settings_updated", self, "settings_updated")


var can_travel := false setget set_can_travel

func _process(_delta: float) -> void:
	$Canvas/Container/Label.text = str(Engine.get_frames_per_second(), "fps")
	if map.visible:
		map.get_node("Viewport/Map/Line/Path").offset = current_subway.offset

#	LOW					MEDIUM					HIGH
#	no lights			no shadows				lights + shadow
#												
#
#
#
#

func settings_updated() -> void:
	var _value = GameManager.settings.get("3d_quality")
	match _value:
		0:
			update_lights_and_shadows(false, false)
		1:
			update_lights_and_shadows(true, false)
		2:
			update_lights_and_shadows(true, true)
	$WorldEnvironment.environment.glow_high_quality = _value != 0
	$WorldEnvironment.environment.fog_enabled = _value != 0
	$WorldEnvironment.environment.ssao_enabled = _value != 0
	$WorldEnvironment.environment.ss_reflections_enabled = _value != 0
	$WorldEnvironment.environment.ss_reflections_max_steps = 512 if _value == 2 else 64

func update_lights_and_shadows(show_light : bool, enable_shadow : bool) -> void:
	if !show_light:
		$WorldEnvironment.environment.ambient_light_color = Color(0.5, 0.5, 0.5)
	else:
		$WorldEnvironment.environment.ambient_light_color = Color(0.25, 0.25, 0.25)
	for light_group in get_tree().get_nodes_in_group("LightsGroup"):
		for light in light_group.get_children():
			light.visible = show_light
			light.shadow_enabled = enable_shadow


var current_subway : Spatial

func _player_entered_subway(subway : Spatial) -> void:
	current_subway = subway
	map.visible = true

func _player_exited_subway(subway : Spatial) -> void:
	current_subway = null
	map.visible = false

func set_can_travel(value : bool) -> void:
	can_travel = value
	if can_travel:
		$Canvas/Container/TravelZoneName.text = GameManager.STATIONS[$Station.current_station].name
	$Canvas/Container/TravelZoneName.visible = can_travel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("mouse_left") && can_travel:
		transition.transition_to_scene(GameManager.STATIONS[$Station.current_station].scene)
		
