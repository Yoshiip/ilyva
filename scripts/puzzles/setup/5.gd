extends BasePuzzleHandler

# la solution (dans cet ordre!!!)
# seq 3
# startm99
# set_inputs 1 2 3
# fill 00 199 299 400 199 302 400 099 599
# execute

var used_seq := false

func interface_changed(content):
	if content.strip_edges() == "1\n2\n3":
		used_seq = true

func program_executed (_starting_point, _R, _A, _B, output):
	if used_seq and output == 6:
		grant_victory()
