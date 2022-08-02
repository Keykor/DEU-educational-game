extends TextureButton

export (String) var item_name = ""

func _ready():
	var controller = get_parent().get_parent()
	
	if (not controller.outline_items):
		$AnimationPlayer.play("IDLE")
	else:
		$AnimationPlayer.play("MOVE")
		if (not OS.has_feature("HTML5")) :
			set_material(load("res://Interactuables/OutlineShader.tres"))

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": rect_position.x,
		"pos_y": rect_position.y,
		"is_visible": is_visible(),
		"item_name": item_name,
		"size_x": rect_size.x,
		"size_y": rect_size.y
	}
	return save_dict

func _on_InteractuableTextureButton_pressed():
	hide()
	var controller = get_parent().get_parent()
	controller.save_item(item_name)
	controller.play_sound("Agarrar.wav")
