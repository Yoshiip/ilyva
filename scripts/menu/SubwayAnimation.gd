extends Spatial


export var speed = 15.0


export(Resource) var subway_mesh

export var part_count := 4

func _ready() -> void:
	for i in part_count:
		var _mesh = subway_mesh.instance()
		if i != 0:
			_mesh.get_node("FrontWall").queue_free()
		else:
			_mesh.get_node("FrontSeparation").queue_free()
		if i != part_count - 1:
			_mesh.get_node("BackWall").queue_free()
		else:
			_mesh.get_node("BackSeparation").queue_free()
		_mesh.translation.z = i * 14.4 - 14.4 * 2
		add_child(_mesh)

export var backward := false

func _process(delta: float) -> void:
	translation.z += delta * speed
	if translation.z > 14.4:
		translation.z -= 14.4
