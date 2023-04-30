extends Panel

var current_item : TextureRect




func hovered(item : TextureRect) -> void:
	visible = true
	rect_global_position.x = item.rect_global_position.x - rect_size.x / 2.0 + item.rect_size.x / 2.0
	$Tween.interpolate_property(self, "rect_position:y", 64, 80, 0.25)
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.25)
	$Icon.texture = item.texture
	$Tween.start()
	current_item = item
	
	$Title.text = item.item_name
	$Description.text = item.item_description

func unhovered(item : TextureRect) -> void:
	if current_item == item:
		$Tween.interpolate_property(self, "rect_position:y", 80, 96, 0.25)
		$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.25)
		$Tween.start()
		current_item = null

func _process(_delta: float) -> void:
	if modulate.a == 0.0:
		visible = false
