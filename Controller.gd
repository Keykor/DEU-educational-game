extends Node2D

func _ready():
	get_node("Timer").start()
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	print("Se termino el juego bro")
	pass
