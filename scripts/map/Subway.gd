extends Spatial

var input : Vector3

var acceleration = 0.0
var steer = 0.0

export var trains_counts := 10
onready var train := preload("res://models/subway/subway.glb")

onready var path: Path = $"../Line1"

func _ready() -> void:
	for i in trains_counts:
		var t = train.instance()
		t.name = str(i)
		add_child(t)
		var p = PathFollow.new()
		p.name = str(i)
		p.rotation_mode = PathFollow.ROTATION_ORIENTED
		path.add_child(p)

func get_input(delta : float) -> void:
	acceleration += Input.get_axis("deccelerate", "accelerate") * delta * 10.0
	acceleration *= 0.975
#	rotation_degrees.y -= Input.get_axis("turn_left", "turn_right") * delta * 180.0
	
var progress = 0.0

func _process(delta: float) -> void:
	get_input(delta)
	progress += acceleration
	for i in trains_counts:
		
		path.get_child(i).offset = progress - i * 8.0
		get_child(i).transform = path.get_child(i).transform
