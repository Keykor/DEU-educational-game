extends Button

var item_name

func _ready():
	item_name = "Smile"
	var parent = get_parent().get_parent()
	self.connect("pressed", parent, "_on_save_item", [item_name])
