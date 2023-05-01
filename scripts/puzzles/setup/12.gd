extends BasePuzzleHandler

# la solution en une seule ligne :
# cat .codes.csv | grep $(cat cellules/mathieu | cut -d ":" -f 2) | cut -d "," -f 2
# Et là, la solution pour les flemmmmmards :
# echo BOGOSS

const NUMBER_OF_LINES := 200 # le nombre de lignes dans "codes.csv"
const CODES = [
	{
		"number": 14,
		"code": "QUEEN"
	},
	{
		"number": 15,
		"code": "DR.WHO"
	},
	{
		"number": 12,
		"code": "DEV"
	},
	{
		"number": 42,
		"code": "HEROBRINE"
	},
	{
		"number": 22,
		"code": "EXCLU"
	},
	{
		"number": 22,
		"code": "EXCLU"
	},
	{
		"number": 99,
		"code": "INENGLISHPLEASE"
	},
	{
		"number": 13,
		"code": "MATHS"
	},
	{
		"number": 640,
		"code": "SWITCH"
	}
]

var system := System.new([
	SystemElement.new(1, "cellules", "/", "", [
		SystemElement.new(1, "isolement", "/cellules", "", [
			SystemElement.new(0, "tanguy", "/cellules/isolement", "15", [], "root", "root"),
			SystemElement.new(0, "carle", "/cellules/isolement", "640", [], "root", "root"),
			SystemElement.new(0, "pierre", "/cellules/isolement", "4", [], "root", "root")
		], "root", "root"),
		SystemElement.new(0, "matys", "/cellules", "22", [], "root", "root"),
		SystemElement.new(0, "noé", "/cellules", "13", [], "root", "root"),
		SystemElement.new(0, "bourgeois", "/cellules", "14", [], "root", "root"),
		SystemElement.new(0, "delecroix", "/cellules", "12", [], "root", "root"),
		SystemElement.new(0, "mathieu", "/cellules", "10", [], "root", "root"),
		SystemElement.new(0, "elise", "/cellules", "99", [], "root", "root"),
	], "root", "root")
])

func _ready():
	var file := SystemElement.new(0, ".codes.csv", "/", "", [], "root", "root")
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var content := "numéro,code\n"
	var index_of_mathieu := rng.randi_range(0, NUMBER_OF_LINES)
	for i in range(0, NUMBER_OF_LINES):
		if index_of_mathieu == i:
			content += "10,BOGOSS\n"
			continue
		var index := rng.randi_range(0, CODES.size() - 1)
		content += str(CODES[index].number) + "," + CODES[index].code + "\n"
	file.content = content
	system.root.append(file)

func interface_changed(content: String) -> void:
	if content.to_lower().strip_edges() == "bogoss":
		grant_victory()
