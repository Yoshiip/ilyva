extends BasePuzzleHandler

# la solution en une seule ligne :
# rat="Hello Rats" ; echo $rat

var variable_created := false

func variable_set(name, value, is_new) -> void:
	if name == "rat" and value.to_lower() == "hello rats":
		variable_created = true

func interface_changed(content) -> void:
	if variable_created and content.to_lower().strip_edges() == "hello rats":
		grant_victory()
