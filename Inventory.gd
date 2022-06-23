extends ColorRect

var items = []
var right_pressed
var left_pressed

func _ready():
	right_pressed = false
	left_pressed = false

func save_item(item_name):
	var item = load("res://Scenes/Items/" + item_name + ".tscn").instance()
	items.append(item)
	$Scroll/Container.add_child(item)
	pass

func reset():
	for item in items:
		item.queue_free()
	items = []

func have_five_smiles():
	var count = 0
	for item in items:
		if item.name_is("Smile"):
			count = count + 1
	return count > 4

func _process(delta):
	print(delta)
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
