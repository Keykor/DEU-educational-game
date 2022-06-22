extends Node2D

signal change_scene(scene_name)

func _ready():
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)
	pass

func _on_start_button_pressed():
	get_parent().clear_persistence()
	get_parent().start_game()
	_on_button_pressed("GameKitchen")
	pass
