extends Node2D

signal change_scene(scene_name)
signal save_item(item_name)

func _ready():
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)
	pass

func _on_item_pressed(item_name):
	print(item_name)
	emit_signal("save_item", item_name)
