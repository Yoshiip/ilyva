extends Control

func _ready() -> void:
	if !GameManager.extra:
		start()

func start() -> void:
	if get_tree().change_scene("res://scenes/Menu.tscn") != OK:
		print("error while changing scene")

func _on_Non_pressed() -> void:
	GameManager.settings.enable_3d = false
	start()


func _on_Oui_pressed() -> void:
	GameManager.settings.enable_3d = true
	start()
