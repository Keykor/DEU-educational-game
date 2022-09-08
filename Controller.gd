extends Node2D

onready var active_scene = $MainMenu
var game_time = 144.0
var language = "es_AR"
var electric_switch = true
var outline_items = false
var activity_time = 5
var music_volume = 0
var sounds_volume = 0
var voices_volume = 0

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
	electric_switch = true
	$Inventory.show()
	$Timer.show()
	$ActivityTimer.start(activity_time)
	$Pause.show()
	$FirstFloorbtn.show()
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
	if scene_name == "GameSecondFloor":
		next_scene.connect("terminar_preparativos", self, "_on_terminar_preparativos")
	else:
		next_scene.connect("change_scene", self, "_on_change_scene")
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
		mistakes.append("$$mistake stay downstairs")
	
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
	$PersistManager.save_scene_ram(scene_name)

func load_scene(scene_name):
	$PersistManager.load_scene_ram(scene_name)

func clear_persistence():
	$PersistManager.clear_persistence_ram()

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
	$SettingsPopup.enable_difficulty()

func _on_PauseSettings_pressed():
	$SettingsPopup.disable_difficulty()
	$SettingsPopup.popup()

func _on_Close_pressed():
	$SettingsPopup.hide()
	$SettingsPopup.enable_difficulty()

func _on_SecondFloorbtn_pressed():
	_on_change_scene("GameSecondFloor")
	$SecondFloorbtn.hide()
	$FirstFloorbtn.show()

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

func play_sound(name):
	$Sounds.stream = load("res://Assets/Sounds/" + name)
	$Sounds.play()
	
func move_item_from_person_to_shelf(item_name):
	return $Inventory.move_item_from_person_to_shelf(item_name)
