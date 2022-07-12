extends Node2D

signal change_scene(scene_name)

func _ready():
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)

func _on_start_button_pressed():
	get_parent().clear_persistence()
	get_parent().start_game()
	_on_button_pressed("GameKitchen")


func _on_SettingsButton_pressed():
	get_parent().find_node("SettingsPopup").popup()

func _on_PlayIntroButton_pressed():
	get_parent().play_intro()
