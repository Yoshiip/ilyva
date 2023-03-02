extends KinematicBody

var speed = 4
const ACCEL_DEFAULT = 7
const ACCEL_AIR = 3
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
export var jump = 2

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

onready var noise := NoiseTexture.new()

func _ready():
	#hides the cursor
	noise.noise = OpenSimplexNoise.new()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	i += delta
	handle_camera(delta)
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
#	if Engine.get_frames_per_second() > Engine.iterations_per_second:
#		camera.set_as_toplevel(true)
#		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
#		camera.rotation.y = rotation.y
#		camera.rotation.x = head.rotation.x
#	else:
#		camera.set_as_toplevel(false)
#		camera.global_transform = head.global_transform


var trauma := 1.0

func get_noise(noise : NoiseTexture, noise_i : float, speed) -> float:
	return noise.noise.get_noise_1d(noise_i * speed)


var shake_offset := 0.0



var was_on_floor := false
var fall_length := 0.0

var i = 0.0



func _physics_process(delta):
	#get keyboard input
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var h_input = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	camera.translation = shake_translation
	camera.rotation_degrees = shake_rotation
	
	

	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)

var shake_rotation : Vector3
var shake_translation : Vector3

func handle_camera(delta : float) -> void:
	var max_shake = 0
	if get_parent().get_node("MovingSubway").player_inside:
		max_shake = get_parent().get_node("MovingSubway").speed / 3.0


	shake_rotation = Vector3(
	max_shake * trauma * get_noise(noise, i, 100),
	max_shake * trauma * get_noise(noise, i + 10.0, 100),
	max_shake * trauma * get_noise(noise, i + 20.0, 100))
	
	shake_translation = Vector3(rand_range(-shake_offset, shake_offset),
	rand_range(-shake_offset, shake_offset),
	rand_range(-shake_offset, shake_offset))
