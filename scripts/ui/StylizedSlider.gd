extends HBoxContainer

export var label := ""
export var settings_to_update := ""

export var default := 50.0
export var min_value := 0.0
export var max_value := 100.0


func _ready() -> void:
	
	
	$Label.text = label
	$Slider.min_value = min_value
	$Slider.max_value = max_value
	$Value.min_value = min_value
	$Value.max_value = max_value

	if settings_to_update != "":
		$Slider.value = GameManager.settings[settings_to_update]
		$Value.value = GameManager.settings[settings_to_update]
	
	$Min.text = str("    ", min_value)
	$Max.text = str(max_value, "    ")
	
	if get_parent().connect("resized", self, "_resize") != OK:
		print("error while connecting")
	
	if $Slider.connect("value_changed", self, "_value_changed") != OK:
		print("error while connecting")
	if $Value.connect("value_changed", self, "_value_changed") != OK:
		print("error while connecting")

func _resize() -> void:
	$Slider.rect_min_size.x = get_parent().rect_size.x - ($Label.rect_size.x + $Value.rect_size.x + 32 + $Min.rect_size.x + $Max.rect_size.x)

func _value_changed(value) -> void:
	$Slider.value = value
	$Value.value = value
	GameManager.settings[settings_to_update] = value
