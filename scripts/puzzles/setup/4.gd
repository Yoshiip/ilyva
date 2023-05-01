extends BasePuzzleHandler

var system := System.new([
	SystemElement.new(1, "residents", "/", "", [
		SystemElement.new(0, "list.txt", "/residents", "0 Nicolas\n1 Patrick\n2 Jerôme\n3 Clément\n4 Thierry\n5 David\n", [], "root", "root"),
		SystemElement.new(0, "codes.txt", "/residents", "0 5f50fc\n1 647da6\n2 1fdf48\n3 451acf\n4 59d9c6\n5 16d674\n", [], "root", "root")
	], "root", "root")
])

# la solution en une seule ligne :
# echo 451acf

func interface_changed(content):
	if content.strip_edges() == "451acf":
		grant_victory()
