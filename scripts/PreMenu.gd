extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "HTML5":
		start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#	yield(get_tree().create_timer(1.0), "timeout")


func start() -> void:
#	if GameManager.settings.enable_3d:
	get_tree().change_scene("res://scenes/Menu.tscn")
#	else:
#		get_tree().change_scene("res://scenes/MenuSimplified.tscn")

func _on_Non_pressed() -> void:
	GameManager.settings.enable_3d = false
	start()


func _on_Oui_pressed() -> void:
	GameManager.settings.enable_3d = true
	start()
