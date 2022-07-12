extends TextureButton

func _ready():
	pass

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": rect_position.x,
		"pos_y": rect_position.y,
		"is_visible": is_visible()
	}
	return save_dict

func _on_InteractuableTextureButton_pressed(item_name):
	hide()
	var controller = get_parent().get_parent()
	controller.save_item(item_name)
