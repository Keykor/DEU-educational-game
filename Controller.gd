extends Node2D

onready var active_scene = $MainMenu

func _ready():
	active_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.connect("save_item", self, "_on_save_item")
	pass

func _process(delta):
	pass

func start_timer():
	$Timer.start_game()

func get_actual_time():
	return $Timer/Label.text

func stop_timer():
	$Timer.end_game()

func continue_timer():
	$Timer.continue_game()
	
func pause_timer():
	$Timer.pause_game()

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
	next_scene.connect("save_item", self, "_on_save_item")
	active_scene.queue_free()
	active_scene = next_scene
	pass

func _on_save_item(item_name):
	print(item_name)
	$Inventory.save_item(item_name)
