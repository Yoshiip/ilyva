extends BasePuzzleHandler

# la solution :
# nano (et ajouter les lignes manuellement)
# cat toto | tail +2

var system := System.new([
	SystemElement.new(0, "toto", "/", "tata", [], "root", "root")
])

func interface_changed(content: String) -> void:
	var low = content.to_lower().strip_edges()
	if low == "bonjour\nje\nsuis\ntres\ncontent" || low == "bonjour\nje\nsuis\ntrès\ncontent":
		grant_victory()
