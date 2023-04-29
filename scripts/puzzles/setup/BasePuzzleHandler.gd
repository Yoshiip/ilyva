extends Node

class_name BasePuzzleHandler


# c'est tous les signaux du terminal, pour en utiliser un dans un sous-script, tu met sous le nom de la méthode (ne pas oublier les arguments sinon ça CRASH)
const SIGNALS := [
	"command_executed",
	"error_thrown",
	"permissions_changed",
	"file_created",
	"file_destroyed",
	"file_changed",
	"file_read",
	"file_copied",
	"file_moved",
	"directory_changed",
	"interface_changed",
	"manual_asked",
	"variable_set",
	"script_executed",
	"help_asked",
]


func terminal_created(reference : Control) -> void: # elle se lance quand un terminal est créé
	var _i := 0
	
	for signal_name in SIGNALS:
		if has_method(signal_name):
			reference.terminal.connect(signal_name, self, signal_name)
			print("Connected " + signal_name)
			_i += 1
	print(str("Connected ", _i, " signal(s)"))

func grant_victory() -> void: # donne la victoire au joueur
	get_tree().current_scene.puzzle_ended()
