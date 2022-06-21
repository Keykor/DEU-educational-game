extends Node2D

signal change_scene(scene_name)
signal change_dificultad(dificultad)

func _ready():
	set_dificultades()
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	emit_signal("change_scene", scene_name)
	pass

func set_dificultades():
	var parent = get_tree().get_current_scene()
	self.connect("change_dificultad", parent, "_on_change_dificultad")
	$Dificultad/MenuButton.get_popup().add_item("Facil")
	$Dificultad/MenuButton.get_popup().add_item("Medio")
	$Dificultad/MenuButton.get_popup().add_item("Dificil")
	$Dificultad/MenuButton.get_popup().connect("id_pressed", self, "_on_dificultad_pressed")
	pass

func _on_dificultad_pressed(id):
	var dificultad = 30.0
	var item_name = $Dificultad/MenuButton.get_popup().get_item_text(id)
	if (item_name == "Facil"):
		dificultad = 30.0
	if (item_name == "Medio"):
		dificultad = 20.0
	if (item_name == "Dificil"):
		dificultad = 10.0
	$Dificultad/MenuButton.text = item_name
	emit_signal("change_dificultad", dificultad)
