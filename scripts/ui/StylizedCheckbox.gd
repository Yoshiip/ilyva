extends TextureRect


export var checked := false setget set_checked

export var property := ""

func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if checked:
		$Check.rect_position = lerp($Check.rect_position, Vector2(rand_range(-15, -5), rand_range(-25, -15)), 0.1)
	else:
		$Cross.rect_position = lerp($Cross.rect_position, Vector2(rand_range(-20, -10), rand_range(-20, -10)), 0.1)

func set_checked(value : bool) -> void:
	yield($Tween, "ready")
	checked = value
	if checked:
		$Tween.interpolate_property($Cross, "self_modulate", $Cross.self_modulate, Color.transparent, 0.1)
		$Tween.interpolate_property($Check, "self_modulate", $Check.self_modulate, Color.white, 0.1)
		$Tween.interpolate_property($Check, "rect_scale", Vector2.ONE * 2.0, Vector2.ONE, 0.1)
		
	else:
		$Tween.interpolate_property($Check, "self_modulate", $Check.self_modulate, Color.transparent, 0.1)
		$Tween.interpolate_property($Cross, "self_modulate", $Cross.self_modulate, Color.white, 0.1)
		$Tween.interpolate_property($Cross, "rect_scale", Vector2.ONE * 2.0, Vector2.ONE, 0.1)

	$Tween.start()
