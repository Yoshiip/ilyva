extends Label


export var color := Color("db281c")
export(int, 1, 3) var pattern_id := 1


func _ready() -> void:
	$Label.text = text
	$Pattern.texture = load(str("res://images/ui/pattern_", pattern_id, ".png"))
	$ColorRect.modulate = color

func _process(_delta: float) -> void:
	$Pattern.rect_position = lerp($Pattern.rect_position, Vector2.ONE * rand_range(-5, 5), 0.1)
