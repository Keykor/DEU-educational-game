extends HBoxContainer

var items = []

func _ready():
	pass

func save_item(item_name):
	var item = load("res://Scenes/Items/" + item_name + ".tscn").instance()
	items.append(item)
	add_child(item)
	pass
