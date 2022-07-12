extends TextureRect

var item_name = ""

func _ready():
	self.set_size(Vector2(90,90))

func name_is(asked_name):
	return item_name == asked_name

func set_item(texture_name):
	item_name = texture_name
	self.texture = load("res://Assets/Sprites/" + item_name + ".png")
