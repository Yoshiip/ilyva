extends BasePuzzleHandler

# la solution à écrire dans un script :
# for i in $CODE ; do
#  value=$(tail +2 codex.csv | grep $i | cut -d "," -f 2)
#  echo -n $value
# done
# ---
# chmod +x script
# CLEF="./script"

var runtime := BashContext.new([
	{
		"name": "CODE",
		"token": BashToken.new(Tokens.STRING, "B a s t e > a l l", { "quote": '"' })
	}
])

var system := System.new([
	SystemElement.new(0, "codex.csv", "/", "lettre,valeur\na,6\nb,3\nB,30\nc,2\nd,8\ne,9\nf,0\ng,1\nh,10\ni,88\nj,42\nk,69\nl,5\nm,99\nn,11\no,22\np,44\nq,33\nr,7\ns,73\nt,32\nu,90\nv,12\nw,98\nx,97\ny,76\nz,24\n>,00\n", [], "root", "root")
])

const ANSWER = "3067332900655"

func variable_set (name: String, value: String, is_new: bool) -> void:
	if name == "CLEF":
		var path := PathObject.new(value)
		if not path.is_valid:
			return
		var script = system.get_element_with_absolute_path(path)
		if script is SystemElement:
			var result = terminal.execute_file(script, [], [null, null, null])
			var oneline_output := ""
			for output in result.outputs:
				if output.error != null:
					return
				else:
					oneline_output += output.text
			if oneline_output == ANSWER:
#				GameManager.progress["iut"]["Bastum"] += 1
				grant_victory()
