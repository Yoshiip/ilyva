extends Spatial

var input : Vector3

var acceleration = 0.0
var steer = 0.0

export var trains_counts := 10
onready var train := preload("res://prefabs/3d/SubwayPart.tscn")

onready var path: Path = $"../Line1"

func _ready() -> void:
	
	
	for i in trains_counts:
		var _mesh = train.instance()
		_mesh.name = str(i)
		add_child(_mesh)
		var p = PathFollow.new()
		if i != 0:
			_mesh.get_node("BackWall").queue_free()
		else:
			_mesh.get_node("BackSeparation").queue_free()
		if i != trains_counts - 1:
			_mesh.get_node("FrontWall").queue_free()
		else:
			_mesh.get_node("FrontSeparation").queue_free()
		p.name = str(i)
		p.rotation_mode = PathFollow.ROTATION_ORIENTED
		path.add_child(p)

#func get_input(delta : float) -> void:
#	acceleration += Input.get_axis("deccelerate", "accelerate") * delta * 10.0
#	acceleration *= 0.975
#	rotation_degrees.y -= Input.get_axis("turn_left", "turn_right") * delta * 180.0
	
var progress = 0.0

func _process(delta: float) -> void:
#	get_input(delta)
	for i in trains_counts:
		path.get_child(i).offset = progress - i * 14.4
		get_child(i).transform = path.get_child(i).transform
