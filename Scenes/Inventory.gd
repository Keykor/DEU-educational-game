extends HBoxContainer
class_name Smile, "res://Scenes/Items/Smile.tscn"

var items = []

func _ready():
	pass

func save_item(item_name):
	var item = load("res://Scenes/Items/" + item_name + ".tscn").instance()
	items.append(item)
	add_child(item)
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
