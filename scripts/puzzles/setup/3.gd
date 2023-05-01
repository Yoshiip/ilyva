extends BasePuzzleHandler

var ip_address := "192.168.10.1"
var dns := DNS.new([
	{
		"ipv4": "196.168.10.7",
		"ipv6": "",
		"name": "clement.etu",
		"mac": "00-B0-D0-63-C2-26"
	}
])
var system := System.new([
	SystemElement.new(0, "annuaire.txt", "/", "philippe.etu\naymeri.etu\nthomas.etu\nnoe.etu\njulien.etu\nclement.etu\npatricia.etu\nmanon.etu\nnicolas.etu\ntanguy.etu\nelise.etu\npierre.etu\n", [], "root", "root")
])

# la solution en une seule ligne :
# ping clement.etu

func command_executed(command, output) -> void:
	if command.name == "ping" and command.options.size() == 1:
		var option = command.options[0]
		if option.is_word() and option.value == "clement.etu":
			grant_victory()
