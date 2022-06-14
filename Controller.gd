extends Node2D

onready var active_scene = $MainMenu

func _ready():
	active_scene.connect("change_scene", self, "_on_change_scene")
	pass

func _process(delta):
	pass

func start_timer():
	$Timer.start()
	pass

func _on_Timer_timeout():
	var scene_name = "GameLose"
	# Aca va la evaluacion de si ganaste o perdiste y se setea la variable scene_name
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	add_child(next_scene)
	next_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.queue_free()
	active_scene = next_scene
	print("Se termino el juego bro")
	pass

func _on_change_scene(scene_name):
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	add_child(next_scene)
	next_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.queue_free()
	active_scene = next_scene
	pass
