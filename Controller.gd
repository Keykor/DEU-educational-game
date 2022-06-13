extends Node2D

var active_scene

func _ready():
	$Timer.start()
	active_scene = $MainMenu
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	print("Se termino el juego bro")
	pass

func _on_change_scene(scene_name):
	active_scene.queue_free()
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	add_child(next_scene)
	active_scene = next_scene
	pass
