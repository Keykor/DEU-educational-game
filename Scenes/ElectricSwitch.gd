extends TextureButton

var switch = true

func _on_ElectricSwitch_pressed():
	if switch:
		self.texture_normal = load("res://Assets/Sprites/tired_switch.png")
	else:
		self.texture_normal = load("res://Assets/Sprites/energy_switch.png")
	
	var controller = get_parent().get_parent()
	controller.switch_switch()
	switch = !switch
