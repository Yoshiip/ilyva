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

# Parce que on a merdé dans les solutions données à la prof,
# on va faire en sorte que la solution donnée fonctionne quand même.

var FAKE_SOLUTION := [
	BashToken.new(Tokens.PLAIN, "final"),
	BashToken.new(Tokens.EQUALS, "="),
	BashToken.new(Tokens.STRING, "vive les wats", { "quote": '"' }),
	BashToken.new(Tokens.NL, "nl"),
	BashToken.new(Tokens.KEYWORD, "for"),
	BashToken.new(Tokens.PLAIN, "i"),
	BashToken.new(Tokens.KEYWORD, "in"),
	BashToken.new(Tokens.VARIABLE, "final"),
	BashToken.new(Tokens.SEMICOLON, ";"),
	BashToken.new(Tokens.KEYWORD, "do"),
	BashToken.new(Tokens.NL, "nl"),
	BashToken.new(Tokens.PLAIN, "echo"),
	BashToken.new(Tokens.VARIABLE, "i"),
	BashToken.new(Tokens.PIPE, "|"),
	BashToken.new(Tokens.PLAIN, "tr"),
	BashToken.new(Tokens.PLAIN, "w"),
	BashToken.new(Tokens.PLAIN, "r"),
	BashToken.new(Tokens.NL, "nl"),
	BashToken.new(Tokens.KEYWORD, "done"),
	BashToken.new(Tokens.EOI, null),
]

func script_executed (script, _output) -> void:
	var lexer := BashLexer.new(script.content)
	if lexer.tokens_list.size() == FAKE_SOLUTION.size():
		for i in range(0, FAKE_SOLUTION.size()):
			if !FAKE_SOLUTION[i].equals(lexer.tokens_list[i]):
				return
		grant_victory()
