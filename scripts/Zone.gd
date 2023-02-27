extends Node2D

export var zone_id := "unnamed"
export var zone_name := "Unnamed"
export(String, "Morning", "Noon", "Evening") var time
export var start_scene := false
export var music_id := "night"

var in_dialogue = false

func _ready() -> void:
	if GameManager.scene_start_dialogue != zone_id && start_scene:
		var new_dialog = Dialogic.start(zone_id + '/Intro')
		GameManager.scene_start_dialogue = zone_id
		add_child(new_dialog)

	$Canvas/Container/ZoneName.text = zone_name
	$Canvas/Container/Time.text = time

func _process(delta: float) -> void:
	print(in_dialogue)
	for i in get_children():
		if i.get("dialog_node"):
			in_dialogue = true
			return
	in_dialogue = false

func play_music() -> void:
	MusicManager.start_music(music_id)
