extends Node

var scenes_saved_data = {}
var saved_scenes = []

func _ready():
	pass

func save_scene_disk(scene_name):
	if not scene_name in self.saved_scenes:
		self.saved_scenes.append(scene_name)

	var save_game = File.new()
	save_game.open("user://"+ scene_name +".save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func save_scene_ram(scene_name):
	if not scene_name in self.saved_scenes:
		self.saved_scenes.append(scene_name)
		scenes_saved_data[scene_name] = []

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		var node_data = node.call("save")
		scenes_saved_data[scene_name].append(node_data)

func load_scene_disk(scene_name):
	if not scene_name in self.saved_scenes:
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
		new_object.item_name = node_data["item_name"]
		new_object.texture_normal = load("res://Assets/Sprites/" + node_data["item_name"] + ".png")
		new_object.rect_position.x = node_data["pos_x"]
		new_object.rect_position.y = node_data["pos_y"]
		new_object.rect_size.x = node_data["size_x"]
		new_object.rect_size.y = node_data["size_y"]
		
		if node_data.has("is_visible"):
			if node_data["is_visible"] == false:
				new_object.hide()
		
		if node_data.has("collected"):
			if node_data["collected"] == true:
				new_object.has_been_collected()
		
	save_game.close()

func load_scene_ram(scene_name):
	if not scene_name in self.saved_scenes:
		return

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	for node_data in scenes_saved_data[scene_name]:
		if node_data == null:
			continue
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.item_name = node_data["item_name"]
		new_object.texture_normal = load("res://Assets/Sprites/" + node_data["item_name"] + ".png")
		new_object.rect_position.x = node_data["pos_x"]
		new_object.rect_position.y = node_data["pos_y"]
		new_object.rect_size.x = node_data["size_x"]
		new_object.rect_size.y = node_data["size_y"]
		
		if node_data.has("is_visible"):
			if node_data["is_visible"] == false:
				new_object.hide()
		
		if node_data.has("collected"):
			if node_data["collected"] == true:
				new_object.has_been_collected()

func clear_persistence_disk():
	var dir = Directory.new()
	for scene in saved_scenes:
		dir.remove("user://"+ scene +".save")
	saved_scenes = []

func clear_persistence_ram():
	scenes_saved_data = {}
	saved_scenes = []
