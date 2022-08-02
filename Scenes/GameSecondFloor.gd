extends Node2D

signal terminar_preparativos()

func _ready():
	pass 

func _on_TerminarPreparativos_pressed():
	#EMITIR UNA SEÑAL
	emit_signal("terminar_preparativos")
