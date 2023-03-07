extends Spatial

export var stop_id := ""
export var stop_name := ""



export var on_line_1 := false
export var line_1_offset := 0.0

export var on_line_2 := false
export var line_2_offset := 0.0

func _ready() -> void:
	$Label.text = stop_name
