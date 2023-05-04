extends BasePuzzleHandler

const PRICE = 10
const OUR_MONEY = 100

var system := System.new([
	SystemElement.new(1, "compte_personnel", "/", "", [
		SystemElement.new(0, "balance.dat", "/compte_personnel", str(OUR_MONEY), [], "root", "root", "500"),
	], "root", "root"),
	SystemElement.new(1, "magasin", "/", "", [
		SystemElement.new(0, "batterie.dat", "/magasin", str(PRICE), [], "root", "root", "500"),
	], "root", "root"),
])

# la solution en une seule ligne :
# mv compte_personnel/balance.dat magasin/batterie.dat
# ---
# alternative : mv compte_personnel/balance.dat magasin

func command_executed(_command, _output) -> void:
	# Bon la plupart des joueurs font n'imp
	# du coup si on mouve la thune vers le `batterie.dat` c'est bon
	# et si on mouve la thune dans le dossier `magasin` c'est good aussi.
	# Pour éviter les tricheurs, j'ai fait en sorte que si les fichiers n'ont pas leur contenu original, bah ça passera pas._add_documentation_page
	var batterie = system.get_element_with_absolute_path(PathObject.new("/magasin/batterie.dat"))
	var balance = system.get_element_with_absolute_path(PathObject.new("/magasin/balance.dat"))
	if batterie is SystemElement:
		if batterie.content.strip_edges() != str(PRICE):
			return
		if balance is SystemElement:
			if balance.content.strip_edges() != str(OUR_MONEY):
				return
			grant_victory()
		else:
			if batterie.content.strip_edges().is_valid_integer():
				var price := int(batterie.content)
				if price > PRICE:
					# ça veut dire que "balance.dat" a été fusionné avec "batterie.dat"
					grant_victory()
