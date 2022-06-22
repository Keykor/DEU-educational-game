extends Button

var item_name

func _ready():
	item_name = "Smile"
	var controller = get_parent().get_parent()
	self.connect("pressed", controller, "_on_save_item", [item_name])

func _pressed():
	hide()

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": rect_position.x,
		"pos_y": rect_position.y,
		"is_visible": is_visible()
	}
	return save_dict
