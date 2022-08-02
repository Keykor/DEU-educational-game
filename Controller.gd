extends Node2D

onready var active_scene = $MainMenu
var game_time = 30.0
var language = "$$spanish"
var electric_switch = true
var saved_scenes = []
var outline_items = false
var activity_time = 5

func _ready():
	OS.window_maximized = true
	$Hint.hide()
	$Inventory.hide()
	$Timer.hide()
	$Pause.hide()
	$FirstFloorbtn.hide()
	$PausePopup.hide()
	$SecondFloorbtn.hide()
	$SettingsPopup.hide()
	clear_persistence()
	electric_switch = true
	active_scene.connect("change_scene", self, "_on_change_scene")
	pass

func _process(delta):
	pass

func start_game():
	$Inventory.show()
	$Timer.show()
	$ActivityTimer.start(activity_time)
	$Pause.show()
	$FirstFloorbtn.show()
	$Estante.show()
	$Timer.set_game_time(game_time)
	$Timer.start_game()
	$Radio.stream = load("res://Assets/Sounds/Juego.wav")
	$Radio.play()

func get_actual_time():
	return $Timer/Label.text

func stop_game():
	$Pause.hide()
	$Inventory.hide()
	$SecondFloorbtn.hide()
	$FirstFloorbtn.hide()
	$Hint.hide()
	$Estante.hide()
	$ActivityTimer.stop()
	$Timer.hide()
	$Timer.end_game()

func continue_game():
	$Timer.continue_game()

func pause_game():
	$Timer.pause_game()

func _on_Timer_timeout():
	stop_game()

	var response = evaluation()
	$Inventory.reset()

	var scene_name = "GameLose"
	$Radio.stream = load("res://Assets/Sounds/Final_malo.wav")
	if (response["win"]):
		scene_name = "GameWin"
		$Radio.stream = load("res://Assets/Sounds/Final_bueno.wav")

	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	next_scene.init(self.translate_mistakes(response["mistakes"]))
	add_child(next_scene)
	next_scene.connect("change_scene", self, "_on_change_scene")
	active_scene.queue_free()
	active_scene = next_scene
	print("Game ended")
	$Radio.play()
	pass

func translate_mistakes(mistakes):
	var full_message = ""
	for mistake in mistakes:
		full_message += "- "
		full_message += TranslationServer.translate(mistake)
		full_message += "\n"
	return full_message
	
func _on_change_scene(scene_name):
	save_scene(active_scene.name)
	var next_scene = load("res://Scenes/" + scene_name + ".tscn").instance()
	add_child(next_scene)
	move_child(next_scene,0)
	next_scene.connect("change_scene", self, "_on_change_scene")
	if scene_name == "GameSecondFloor":
		next_scene.connect("terminar_preparativos", self, "_on_terminar_preparativos")
	active_scene.queue_free()
	active_scene = next_scene
	load_scene(active_scene.name)
	if scene_name != "GameLoundryRoom":
		$SecondFloorbtn.hide()
	else:
		$SecondFloorbtn.show()
	if scene_name == "MainMenu":
		$Radio.stream = load("res://Assets/Sounds/Menu.wav")
		$Radio.play()	
	play_sound("Pasos.wav")
	

func _on_terminar_preparativos():
	$EndGamePopup.show()

func save_item(item_name):
	$Inventory.save_item(item_name)

func evaluation():
	var mistakes = []
	
	if (active_scene.name != "SecondFloor"):
		mistakes.append("No subiste al segundo piso de la casa")
	
	if (electric_switch):
		mistakes.append("$$mistake energy")
		
	var response = $Inventory.has_all_the_necessary_for_the_win()
	
	if (!response["needed_items"]):
		mistakes.append("$$mistake important items")
		
	if (!response["toxic_items"]):
		mistakes.append("$$mistake toxic items")
		
	return {
		"win": mistakes.empty(),
		"mistakes": mistakes
	}

func _on_change_difficulty(difficulty):
	self.game_time = difficulty

func _on_change_language(lang):
	self.language = lang

func save_scene(scene_name):
	if not scene_name in self.saved_scenes:
		self.saved_scenes.append(scene_name)

	var save_game = File.new()
	save_game.open("user://"+ scene_name +".save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_scene(scene_name):
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
		if node_data["is_visible"] == false:
			new_object.hide()
	save_game.close()

func clear_persistence():
	var dir = Directory.new()
	for scene in saved_scenes:
		dir.remove("user://"+ scene +".save")
	saved_scenes = []

func _on_Pause_pressed():
	get_tree().paused = true
	$PausePopup.show()

func _on_ResumeGame_pressed():
	get_tree().paused = false
	$PausePopup.hide()

func _on_Salir_pressed(scene_name):
	get_tree().paused = false
	$Inventory.hide()
	$Inventory.reset()
	$ActivityTimer.stop()
	$Hint.hide()
	$Timer.hide()
	$Timer.stop()
	$Estante.hide()
	$SecondFloorbtn.hide()
	$FirstFloorbtn.hide()
	$Pause.hide()
	$PausePopup.hide()
	clear_persistence()
	_on_change_scene(scene_name)
	$Radio.stream = load("res://Assets/Sounds/Menu.wav")
	$Radio.play()

func _on_Back_pressed():
	$SettingsPopup.hide()

func _on_PauseSettings_pressed():
	$InGameSettingsPopup.popup()

func _on_Close_pressed():
	$InGameSettingsPopup.hide()

func _on_SecondFloorbtn_pressed():
	_on_change_scene("GameSecondFloor")
	$SecondFloorbtn.hide()
	$FirstFloorbtn.show()
	$Estante.show()

func _on_ContinueGame_pressed():
	$EndGamePopup.hide()

func _on_EndGame_pressed():
	$EndGamePopup.hide()
	_on_Timer_timeout()

func switch_switch():
	electric_switch = !electric_switch

func play_intro():
	save_scene(active_scene.name)
	var next_scene = load("res://Scenes/Intro.tscn").instance()
	add_child(next_scene)
	active_scene.hide()
	move_child(next_scene,0)

func _on_ActivityTimer_timeout():
	$Hint.show()

func _input(event):
	if event is InputEventMouse and event.is_pressed() and not $Timer.is_stopped():
		$ActivityTimer.start(activity_time)
		$Hint.hide()

func _on_FirstFloorbtn_pressed():
	_on_change_scene("GameLoundryRoom")
	$SecondFloorbtn.show()
	$FirstFloorbtn.hide()
	$Estante.hide()

func play_sound(name):
	$Sounds.stream = load("res://Assets/Sounds/" + name)
	$Sounds.play()
