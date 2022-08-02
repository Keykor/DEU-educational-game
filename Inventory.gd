extends ColorRect

var items_on_person = []
var items_on_shelf = []
var right_pressed
var left_pressed

func _ready():
	right_pressed = false
	left_pressed = false

func save_item(item_name):
	var item = load("res://Scenes/Item.tscn").instance()
	item.set_item(item_name)
	items_on_person.append(item)
	$Scroll/Container.add_child(item)
	pass

func reset():
	for item in items_on_person:
		item.queue_free()
	items_on_person = []
	items_on_shelf = []

func has_all_the_necessary_for_the_win():
	var needed_items = ["water_bottle","money","female_dni","medikit", "flashlight", "radio", "male_dni"]
	var toxic_items = ["cif","raid"]
	for item in items_on_shelf:
		var i = needed_items.find(item)
		if (i != -1):
			needed_items.pop_at(i)
		i = toxic_items.find(item)
		if (i != -1):
			toxic_items.pop_at(i)
	return {
		"needed_items": needed_items.empty(),
		"toxic_items": toxic_items.empty()
	}

func _process(delta):
	if right_pressed == true:
		$Scroll.set_h_scroll($Scroll.get_h_scrollbar().value+(300*delta))
	elif left_pressed == true:
		$Scroll.set_h_scroll($Scroll.get_h_scrollbar().value-(300*delta))

func _on_Right_button_down():
	right_pressed = true

func _on_Right_button_up():
	right_pressed = false
	
func _on_Left_button_down():
	left_pressed = true

func _on_Left_button_up():
	left_pressed = false

func move_item_from_person_to_shelf(item_name):
	var item_to_move = null
	for item in items_on_person:
		if item.item_name == item_name:
			item_to_move = item
		
	if item_to_move != null:
		items_on_shelf.append(item_to_move.item_name)
		items_on_person.erase(item_to_move)
		item_to_move.queue_free()
		get_parent().play_sound("Bien.wav")
		return true
	else:
		get_parent().play_sound("Error.wav")
		return false
