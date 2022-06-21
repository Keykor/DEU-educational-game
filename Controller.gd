extends Node2D

onready var active_scene = $MainMenu
var game_time = 30.0
var aparato = false
var saved_scenes = []

func _ready():
	active_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.connect("save_item", self, "_on_save_item")
	pass

func _process(delta):
	pass

func start_timer():
	$Timer.set_game_time(game_time)
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
	var text = evaluation()
	$Inventory.reset()
	
	var scene_name = "GameLose"
	if (text == ""):
		scene_name = "GameWin"
		
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	next_scene.init(text)
	add_child(next_scene)
	next_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.queue_free()
	active_scene = next_scene
	print("Game ended")
	pass

func _on_change_scene(scene_name):
	save_game(active_scene.name)
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	add_child(next_scene)
	next_scene.connect("change_scene", self, "_on_change_scene")
	next_scene.connect("save_item", self, "_on_save_item")
	active_scene.queue_free()
	active_scene = next_scene
	load_game(active_scene.name)
	pass

func _on_save_item(item_name):
	print(item_name)
	$Inventory.save_item(item_name)

func evaluation():
	var text = ""
	if (aparato):
		text = text + "- No apagaste el aparato \n"
	if (not $Inventory.have_five_smiles()):
		text = text + "- No conseguiste 5 caras \n"
	return text

func _on_change_dificultad(dificultad):
	print(dificultad)
	game_time = dificultad

func save_game(scene_name):
	if not scene_name in saved_scenes:
		saved_scenes.append(scene_name)
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game(scene_name):
	if not scene_name in saved_scenes:
		return
	
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
		
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			if i == "pos_x":
				new_object.rect_position.x = node_data[i]
				continue
			if i == "pos_y":
				new_object.rect_position.y = node_data[i]
				continue
			if i == "hidden":
				if node_data[i] == true:
					new_object.hide()
	save_game.close()

func clear_persistence():
	saved_scenes = []
	var dir = Directory.new()
	dir.remove("user://savegame.save")
