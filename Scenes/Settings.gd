extends Node2D

signal change_scene(scene_name)
signal change_dificultad(dificultad)

var difficulties = {
	"Fácil": 30.0,
	"Medio": 20.0,
	"Difícil": 10.0
}

func _ready():
	for key in difficulties:
		difficulties[difficulties[key]] = key
	set_dificultades()
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	emit_signal("change_scene", scene_name)
	pass

func set_dificultades():
	var controller = get_tree().get_current_scene()
	self.connect("change_dificultad", controller, "_on_change_dificultad")
	var dificultad = controller.game_time
	$Panel/Dificultad/MenuButton.text = self.difficulties[dificultad]
	$Panel/Dificultad/MenuButton.get_popup().add_item("Fácil")
	$Panel/Dificultad/MenuButton.get_popup().add_item("Medio")
	$Panel/Dificultad/MenuButton.get_popup().add_item("Difícil")
	$Panel/Dificultad/MenuButton.get_popup().connect("id_pressed", self, "_on_dificultad_pressed")
	pass

func _on_dificultad_pressed(id):
	var item_name = $Panel/Dificultad/MenuButton.get_popup().get_item_text(id)
	var dificultad = difficulties[item_name]
	$Panel/Dificultad/MenuButton.text = item_name
	emit_signal("change_dificultad", dificultad)
