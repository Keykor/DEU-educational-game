extends Node2D

signal change_scene(scene_name)

func _ready():
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)
	pass


func _on_LinkButton_pressed():
	OS.shell_open($TextureRect/Panel/TextureRect/VBoxContainer/HBoxContainer/LinkButton.text)
