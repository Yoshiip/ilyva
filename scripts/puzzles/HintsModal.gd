extends "res://scripts/ui/Modal.gd"



func _ready() -> void:
	var HintTab : PackedScene = preload("res://prefabs/puzzles/HintTab.tscn")
	for hint in puzzle.hints:
		var _index : int = puzzle.hints.find(hint)
		var _hint_tab := HintTab.instance()
		_hint_tab.name = str("Indice ", _index + 1)
		_hint_tab.get_node("Text").bbcode_text = str("[center]", hint, "[/center]")
		if puzzle.hints_action[_index] == "":
			_hint_tab.get_node("Button").queue_free()
		else:
			if _hint_tab.get_node("Button").connect("pressed", get_tree().current_scene.puzzle_handler, puzzle.hints_action[_index]) != OK:
				print("signal error")
		$Content/Tabs.add_child(_hint_tab)

	if puzzle.get_puzzle_id() != "13":
		var _hint_tab := HintTab.instance()
		_hint_tab.name = str("Passer l'énigme")
		_hint_tab.get_node("Text").bbcode_text = "[center]Des difficultés à faire l'énigme ?\nAppuyez sur ce bouton pour passer l'énigme:[/center]"
		if _hint_tab.get_node("Button").connect("pressed", self, "skip") != OK:
			print("error connection")
		$Content/Tabs.add_child(_hint_tab)

func skip() -> void:
	get_tree().current_scene.skip()
