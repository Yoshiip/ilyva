extends TextureRect


export var checked := false setget set_checked

export var property := ""

func _ready() -> void:
	yield($Tween, "ready")
	
	set_process(false)


func _process(_delta: float) -> void:
	if checked:
		$Check.rect_position = lerp($Check.rect_position, Vector2(rand_range(-15, -5), rand_range(-25, -15)), 0.1)
	else:
		$Cross.rect_position = lerp($Cross.rect_position, Vector2(rand_range(-20, -10), rand_range(-20, -10)), 0.1)

func set_checked(value : bool) -> void:
	checked = value
	if checked:
		$Tween.interpolate_property($Cross, "modulate:a", $Cross.modulate.a, 0.0, 0.1)
		$Tween.interpolate_property($Check, "modulate:a", $Check.modulate.a, 1.0, 0.1)
		$Tween.interpolate_property($Check, "rect_scale", Vector2.ONE * 2.0, Vector2.ONE, 0.1)
		
	else:
		$Tween.interpolate_property($Check, "modulate:a", $Check.modulate.a, 0.0, 0.1)
		$Tween.interpolate_property($Cross, "modulate:a", $Cross.modulate.a, 1.0, 0.1)
		$Tween.interpolate_property($Cross, "rect_scale", Vector2.ONE * 2.0, Vector2.ONE, 0.1)

	$Tween.start()
