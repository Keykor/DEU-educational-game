extends Node2D

signal change_scene(scene_name)

func _ready():
	pass 

func init(arg):
	pass

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)
	pass
