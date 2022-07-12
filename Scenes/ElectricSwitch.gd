extends TextureButton

var switch_on

func _ready():
	var controller = get_parent().get_parent()
	switch_on = controller.electric_switch
	if switch_on:
		self.texture_normal = load("res://Assets/Sprites/energy_switch.png")
	else:
		self.texture_normal = load("res://Assets/Sprites/tired_switch.png")

func _on_ElectricSwitch_pressed():
	var controller = get_parent().get_parent()
	controller.switch_switch()
	switch_on = !switch_on
	
	if switch_on:
		self.texture_normal = load("res://Assets/Sprites/energy_switch.png")
	else:
		self.texture_normal = load("res://Assets/Sprites/tired_switch.png")
