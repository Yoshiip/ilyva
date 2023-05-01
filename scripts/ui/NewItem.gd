extends CanvasLayer

var item_id := "traminus"
var is_sultan := false

var callback := ""

onready var icon: TextureRect = $NewItem/Container/Icon
onready var name_label: Label = $NewItem/Container/Name
onready var description: Label = $NewItem/Container/Description


func _ready() -> void:
	if is_instance_valid(get_tree().current_scene.dialogue_canvas):
		get_tree().current_scene.dialogue_canvas.visible = false
	if is_sultan:
		icon.texture = load("res://images/sultans/" + item_id + ".png")
		name_label.text = item_id.capitalize()
		if GameManager.sultans.size() >= 12:
			description.text = str("Youpi! Vous les avez tous trouver.\nAllez vite le dire à Thomas!")
		else:
			
			description.text = str("Il vous reste ", 12 - GameManager.sultans.size(), " sultans a trouver.")
			if GameManager.sultans.size() < 6:
				description.text += "\nBon courage!"
			elif GameManager.sultans.size() < 11:
				description.text += "\nVous êtes à la moitié!"
			elif GameManager.sultans.size() == 11:
				description.text += "\nPlus qu'un!"
	else:
		icon.texture = GameManager.ITEMS[item_id].icon
		name_label.text = GameManager.ITEMS[item_id].name
		description.text = GameManager.ITEMS[item_id].description


func _on_Close_pressed() -> void:
	$NewItem/AnimationPlayer.play("Close")
	yield(get_tree().create_timer(1.0), "timeout")
	if is_instance_valid(get_tree().current_scene.dialogue_canvas):
		get_tree().current_scene.dialogue_canvas.visible = true
#		get_tree().current_scene.dialogue_canvas.get_node("DialogNode")._state = get_tree().current_scene.dialogue_canvas.get_node("DialogNode").state.IDLE
#	if callback != "":
#		get_tree().current_scene.get_node(callback).interact()
	queue_free()
