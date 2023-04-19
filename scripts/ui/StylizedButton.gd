extends Button

var checkbox


export var checked := false
export var hide_by_default := false

func _ready() -> void:
	checkbox = get_node("Checkbox")
	checkbox.checked = checked
	checkbox.visible = !hide_by_default
	
	if connect("mouse_entered", self, "_mouse_entered") != OK:
		printerr("Error")
	if connect("mouse_exited", self, "_mouse_exited") != OK:
		printerr("Error")

func _pressed() -> void:
	checked = !checked
	checkbox.checked = checked

func _mouse_entered() -> void:
	checkbox.set_process(true)

func _mouse_exited() -> void:
	checkbox.set_process(false)
