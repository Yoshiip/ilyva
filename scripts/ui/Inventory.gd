extends Panel

onready var InventoryItem = preload("res://prefabs/ui/pause/InventoryItem.tscn")

func refresh() -> void:
	for i in $List.get_children():
		i.queue_free()
	for i in GameManager.items:
		var _item : TextureRect= InventoryItem.instance()
		_item.item_name = GameManager.ITEMS[i].name
		_item.item_description = GameManager.ITEMS[i].description
		_item.texture = GameManager.ITEMS[i].icon
		$List.add_child(_item)
