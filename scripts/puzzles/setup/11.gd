extends BasePuzzleHandler

# la solution en une seule ligne :
# for i in $final ; do echo $i | tr w r ; done

# IL DOIT ETRE DIT DANS LES INSTRUCTIONS QUE LA VARIABLE "final" EST DECLAREE.

var runtime := BashContext.new([
	{
		"name": "final",
		"token": BashToken.new(Tokens.STRING, "vive les wats", { "quote": '"' })
	}
])

func interface_changed(content: String) -> void:
	if content.to_lower().strip_edges() == "vive\nles\nrats":
		grant_victory()
