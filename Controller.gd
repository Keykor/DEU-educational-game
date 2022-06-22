extends Node2D

onready var active_scene = $MainMenu
var game_time = 30.0
var aparato = false
var saved_scenes = []

func _ready():
	$InventoryRect.hide()
	$Timer.hide()
	clear_persistence()
	active_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.connect("save_item", self, "_on_save_item")
	pass

func _process(delta):
	pass

func start_timer():
	$InventoryRect.show()
	$Timer.show()
	$Timer.set_game_time(game_time)
	$Timer.start_game()

func get_actual_time():
	return $Timer/Label.text

func stop_timer():
	$InventoryRect.hide()
	$Timer.hide()
	$Timer.end_game()

func continue_timer():
	$Timer.continue_game()
	
func pause_timer():
	$Timer.pause_game()

func _on_Timer_timeout():
	stop_timer()
	
	var text = evaluation()
	$InventoryRect/Inventory.reset()
	
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
	move_child(next_scene,0)
	next_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.queue_free()
	active_scene = next_scene
	load_game(active_scene.name)
	pass

func _on_save_item(item_name):
	print(item_name)
	$InventoryRect/Inventory.save_item(item_name)

func evaluation():
	var text = ""
	if (aparato):
		text = text + "- No apagaste el aparato \n"
	if (not $InventoryRect/Inventory.have_five_smiles()):
		text = text + "- No conseguiste 5 caras \n"
	return text

func _on_change_dificultad(dificultad):
	print(dificultad)
	game_time = dificultad

func save_game(scene_name):
	if not scene_name in saved_scenes:
		saved_scenes.append(scene_name)
	
	var save_game = File.new()
	save_game.open("user://"+ scene_name +".save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game(scene_name):
	if not scene_name in saved_scenes:
		return
	
	var save_game = File.new()
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
		
	save_game.open("user://"+ scene_name +".save", File.READ)
	while not save_game.eof_reached():
		var node_data = parse_json(save_game.get_line())
		if node_data == null:
			continue
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.rect_position.x = node_data["pos_x"]
		new_object.rect_position.y = node_data["pos_y"]
		if node_data["is_visible"] == false:
			new_object.hide()
	save_game.close()

func clear_persistence():
	var dir = Directory.new()
	for scene in saved_scenes:
		dir.remove("user://"+ scene +".save")
	saved_scenes = []
