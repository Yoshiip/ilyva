extends Spatial

onready var map: ViewportContainer = $Canvas/Container/Minimap

var pause_menu
export var debug_mode := false

onready var transition := preload("res://prefabs/Transition.tscn").instance()




func _ready() -> void:
	MusicManager.start_music("subway")
	$Station.station_changed(GameManager.current_subway_stop)
	add_child(transition)
	$"%ZoneName".play_animation(GameManager.STATIONS[$Station.current_station].name)
	pause_menu = preload("res://prefabs/PauseMenu.tscn").instance()
	$Canvas/Container.add_child(pause_menu)

	map.visible = false
	
	settings_updated()
	GameManager.connect("settings_updated", self, "settings_updated")


var can_travel := false setget set_can_travel



#	LOW					MEDIUM					HIGH
#	no lights			no shadows				lights + shadow
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
	if event.is_action_pressed("mouse_left") && can_travel:
		transition.transition_to_scene(GameManager.STATIONS[$Station.current_station].scene)
		
var left_line_used := false
var left_line_waiting := false
var right_line_used := false
var right_line_waiting := false


onready var MovingSubway := preload("res://prefabs/3d/MovingSubway.tscn")

func _process(_delta: float) -> void:
	$Canvas/Container/Label.text = str(Engine.get_frames_per_second(), "fps")
	if map.visible:
		
		map.get_node("Viewport/Map/Line/Path/Icon").scale.y = 1 if current_subway.going_forward else -1
		map.get_node("Viewport/Map/Line/Path").offset = current_subway.offset
	if left_line_waiting && !left_line_used:
		add_subway(false)
	if right_line_waiting && !right_line_used:
		add_subway(true)

func play_zone_animation(arg) -> void:
	$"%ZoneName".play_animation(arg)

func add_subway(left_side : bool) -> void:
	var _sub = MovingSubway.instance()
	_sub.current_stop_id = $Station.current_station
	_sub.going_forward = left_side
	_sub.translation = Vector3((1 if left_side else -1) * 1.8, 0.5, 0)
	add_child(_sub)

func _on_LeftPlatform_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		left_line_waiting = true


func _on_LeftPlatform_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		left_line_waiting = false


func _on_RightPlatform_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		right_line_waiting = true


func _on_RightPlatform_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		right_line_waiting = false
