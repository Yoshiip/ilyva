extends BasePuzzleHandler

var system := System.new([
	SystemElement.new(1, "compte_personnel", "/", "", [
		SystemElement.new(0, "balance.dat", "/compte_personnel", "100", [], "root", "root"),
	], "root", "root"),
	SystemElement.new(1, "magasin", "/", "", [
		SystemElement.new(0, "batterie.dat", "/magasin", "10", [], "root", "root"),
	], "root", "root"),
])

# la solution en une seule ligne :
# mv compte_personnel/balance.dat magasin/batterie.dat

func command_executed(command, output) -> void:
	# Si le joueur a bien fait son coup,
	# le fichier "balance.dat" ne devrait plus exister,
	# et le fichier batterie.bat devrait avoir le contenu originel de "balance.dat" ("100")
	var batterie = system.get_element_with_absolute_path(PathObject.new("/magasin/batterie.dat"))
	var balance = system.get_element_with_absolute_path(PathObject.new("/compte_personnel/balance.dat"))
	print("TEST")
	if batterie is SystemElement:
		if balance == null and batterie.content == "100":
			# ça veut dire que "balance.dat" a été fusionné avec "batterie.dat"
			print("t!!!!")
			grant_victory()
