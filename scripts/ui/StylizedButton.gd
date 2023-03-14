extends Button

export(NodePath) var checkbox


export var checked := false
export var hide_by_default := false

func _ready() -> void:
	if checkbox == "":
		checkbox = get_node("Checkbox").get_path()
	get_node(checkbox).checked = checked
	get_node(checkbox).visible = !hide_by_default
	
	if connect("mouse_entered", self, "_mouse_entered") != OK:
		printerr("Error")
	if connect("mouse_exited", self, "_mouse_exited") != OK:
		printerr("Error")

func _pressed() -> void:
	checked = !checked
	get_node(checkbox).checked = checked

func _mouse_entered() -> void:
	get_node(checkbox).set_process(true)

func _mouse_exited() -> void:
	get_node(checkbox).set_process(false)
