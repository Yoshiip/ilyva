extends BasePuzzleHandler

# la solution :
# nano (et ajouter les lignes manuellement)
# cat toto | tail +2

var system := System.new([
	SystemElement.new(0, "toto", "/", "tata", [], "root", "root")
])

func interface_changed(content: String) -> void:
	if content.to_lower().strip_edges() == "bonjour\nje\nsuis\ntres\ncontent":
		grant_victory()
