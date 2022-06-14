extends Node2D

var time

signal change_scene(scene_name)

func _ready():
	time = get_parent().get_actual_time()
	get_parent().stop_timer()
	pass 

func _on_button_pressed(scene_name):
	print(scene_name)
	#EMITIR UNA SEÑAL
	emit_signal("change_scene", scene_name)
	pass
