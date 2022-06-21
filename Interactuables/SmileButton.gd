extends Button

var item_name

func _ready():
	item_name = "Smile"
	var parent = get_parent().get_parent()
	self.connect("pressed", parent, "_on_save_item", [item_name])

func _pressed():
	hide()

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": rect_position.x,
		"pos_y": rect_position.y,
		"hidden": is_visible()
	}
	return save_dict