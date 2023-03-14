extends Label


export var color := Color("db281c")
export(int, 1, 3) var pattern_id := 1


func _ready() -> void:
	$Label.text = text
	$Pattern.texture = load(str("res://images/ui/pattern_", pattern_id, ".png"))
	$ColorRect.modulate = color

func _process(delta: float) -> void:
	$Pattern.rect_position = lerp($Pattern.rect_position, Vector2(rand_range(-15, 15), rand_range(-15, 15)), 0.1)
