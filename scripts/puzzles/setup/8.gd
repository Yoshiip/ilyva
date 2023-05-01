extends BasePuzzleHandler

# la solution en une seule ligne :
# for i in $(seq 5) ; do echo "Salut" ; done

var system = System.new([])

func interface_changed(content: String) -> void:
	if content.to_lower().strip_edges() == "salut\nsalut\nsalut\nsalut\nsalut":
		grant_victory()

# C'est une fonction qui permet d'ajouter un script.
# Ce script comporte une boucle for qui fait office d'exemple.
func add_help_script() -> void:
	system.root.append(
		SystemElement.new(0, "aide.sh", "/", "texte='je suis un texte'\nfor i in $texte ; do\n\techo $i\ndone", [], "root", "root", "777")
	)
