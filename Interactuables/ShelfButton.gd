extends TextureButton

export (String) var item_name = ""
var collected

func _ready():
	collected = false

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": rect_position.x,
		"pos_y": rect_position.y,
		"collected": collected,
		"item_name": item_name,
		"size_x": rect_size.x,
		"size_y": rect_size.y
	}
	return save_dict

func remove_filter():
	set_material(null)

func has_been_collected():
	collected = true
	remove_filter()
	
func _on_ShelfInteractuableButton_pressed():
	if collected:
		return
	var controller = get_parent().get_parent()
	collected = controller.move_item_from_person_to_shelf(item_name)
	if collected:
		remove_filter()
