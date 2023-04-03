extends "res://scripts/ui/pause/PauseContainer.gd"


onready var SultanBadge := preload("res://prefabs/ui/SultanBadge.tscn")


func _ready() -> void:
	$Hovered.visible = false
	for i in ["achille", "anemone", "boulba", "cocan", "cricri", "crocan", "hector", "nano", "sabine", "simoun", "sultan", "zezette"]:
		var badge := SultanBadge.instance()
		if !GameManager.sultans.has(i):
			badge.get_node("Icon").material = null
			badge.modulate = Color(0, 0, 0, 0.5)
		else:
			badge.connect("mouse_entered", self, "_mouse_entered_badge", [ i ])
			badge.connect("mouse_exited", self, "_mouse_exited_badge")
		badge.get_node("Icon").texture = load("res://images/sultans/" + i + ".png")
		$List/Grid.add_child(badge)



func _mouse_entered_badge(badge_id : String) -> void:
	$Hovered.visible = true
	$Hovered/Icon.texture = load("res://images/sultans/" + badge_id + ".png")
	$Hovered/Name.text = badge_id.capitalize()

func _mouse_exited_badge() -> void:
	$Hovered.visible = false
