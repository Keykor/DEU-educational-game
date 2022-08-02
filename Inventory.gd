extends ColorRect

var items = []
var right_pressed
var left_pressed

func _ready():
	right_pressed = false
	left_pressed = false

func save_item(item_name):
	var item = load("res://Scenes/Item.tscn").instance()
	item.set_item(item_name)
	items.append(item)
	$Scroll/Container.add_child(item)
	pass

func reset():
	for item in items:
		item.queue_free()
	items = []


func has_all_the_necessary_for_the_win():
	var needed_items = ["water_bottle","money","female_dni","medikit", "flashlight", "radio", "male_dni"]
	var toxic_items = ["cif","raid"]
	for item in items:
		var i = needed_items.find(item.item_name)
		if (i != -1):
			needed_items.pop_at(i)
		i = toxic_items.find(item.item_name)
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
