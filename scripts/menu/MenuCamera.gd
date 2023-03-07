extends "res://addons/jm_pp_outlines/jm_pp_outlines_camera.gd"


onready var noise := NoiseTexture.new()

onready var base_pos := translation
onready var base_rot := rotation_degrees

onready var first_position: Position3D = $"../FirstPosition"
onready var alt_position: Position3D = $"../AltPosition"


func go() -> void:
	set_process(true)
	base_pos = translation
	base_rot = rotation_degrees
	$Timer.start()

func _ready():
	noise.noise = OpenSimplexNoise.new()
	set_process(false)


var trauma := 1.0

func get_noise(noise : NoiseTexture, noise_i : float, speed) -> float:
	return noise.noise.get_noise_1d(noise_i * speed)


var shake_offset := 0.0



var was_on_floor := false
var fall_length := 0.0

var i = 0.0

func _process(delta: float) -> void:
	i += delta
	handle_camera(delta)
	
	var m_pos = get_viewport().get_mouse_position()
	var w_size = OS.window_size
	h_offset = lerp(h_offset, ((m_pos.x + (w_size.x / 2)) / w_size.x - 1.0) * 1.5, 0.05)
	v_offset = lerp(v_offset, -((m_pos.y + (w_size.y / 2)) / w_size.y - 1.0) * 1.5, 0.05)
	

func handle_camera(delta : float) -> void:
	var max_shake = get_parent().get_node("Subway").speed / 3.0
	rotation_degrees = Vector3(
	max_shake * trauma * get_noise(noise, i,  100),
	max_shake * trauma * get_noise(noise, i + 10.0, 100),
	max_shake * trauma * get_noise(noise, i + 20.0, 100)) + base_rot
	
	translation = Vector3(rand_range(-shake_offset, shake_offset),
	rand_range(-shake_offset, shake_offset),
	rand_range(-shake_offset, shake_offset)) + base_pos

var on_alt_position := false

func _on_Timer_timeout() -> void:
#	var point = get_parent().get_node(str("Point", randi() % 3))
#	base_pos = point.translation
#	base_rot = point.rotation_degrees
	on_alt_position = !on_alt_position
	if on_alt_position:
		base_pos = alt_position.translation
		base_rot = alt_position.rotation_degrees
	else:
		base_pos = first_position.translation
		base_rot = first_position.rotation_degrees
	$Timer.wait_time = rand_range(15.0, 20.0)
