extends ColorRect

var item_id := "traminus"
var is_sultan := false

var callback := ""

func _ready() -> void:
	if is_sultan:
		$Container/Icon.texture = load("res://images/sultans/" + item_id + ".png")
		$Container/Name.text = item_id.capitalize()
		if GameManager.sultans.size() >= 12:
			$Container/Description.text = str("Youpi! Vous les avez tous trouver.\nAllez vite le dire à Thomas!")
		else:
			
			$Container/Description.text = str("Il vous reste ", 12 - GameManager.sultans.size(), " sultans a trouver.")
			if GameManager.sultans.size() < 6:
				$Container/Description.text += "\nBon courage!"
			elif GameManager.sultans.size() < 11:
				$Container/Description.text += "\nVous êtes à la moitié!"
			elif GameManager.sultans.size() == 11:
				$Container/Description.text += "\nPlus qu'un!"
	else:
		$Container/Icon.texture = GameManager.ITEMS[item_id].icon
		$Container/Name.text = GameManager.ITEMS[item_id].name
		$Container/Description.text = GameManager.ITEMS[item_id].description


func _on_Close_pressed() -> void:
	$AnimationPlayer.play("Close")
	yield(get_tree().create_timer(1.0), "timeout")
	if callback != "":
		get_tree().current_scene.get_node(callback).interact()
	queue_free()
