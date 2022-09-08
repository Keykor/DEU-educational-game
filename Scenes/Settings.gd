extends Popup

signal change_scene(scene_name)
signal change_difficulty(difficulty)

var difficulties = {
	"$$easy": 144.0,
	"$$medium": 96.0,
	"$$hard": 48.0
}

var languages = {
	"$$english": "en_US",
	"$$spanish": "es_AR"
}

var lastLanguageButton = null
var lastDifficultyButton = null

func _ready():
	for key in difficulties:
		difficulties[difficulties[key]] = key
	for key in languages:
		languages[languages[key]] = key
	self.set_difficulties()
	self.set_languages()

func _on_button_pressed(scene_name):
	emit_signal("change_scene", scene_name)

func set_difficulties():
	if not $Panel:
		return
	var controller = get_tree().get_current_scene()
	self.connect("change_difficulty", controller, "_on_change_difficulty")
	$Panel/Difficulty/HBoxContainer/easy.connect("pressed", self, "_on_difficulty_pressed", [$Panel/Difficulty/HBoxContainer/easy])
	$Panel/Difficulty/HBoxContainer/medium.connect("pressed", self, "_on_difficulty_pressed", [$Panel/Difficulty/HBoxContainer/medium])
	$Panel/Difficulty/HBoxContainer/hard.connect("pressed", self, "_on_difficulty_pressed", [$Panel/Difficulty/HBoxContainer/hard])

	lastDifficultyButton = $Panel/Difficulty/HBoxContainer/easy
	lastDifficultyButton.disabled = true

func _on_difficulty_pressed(button):
	if (lastDifficultyButton):
		lastDifficultyButton.disabled = false
	var difficulty = self.difficulties[button.text]
	button.disabled = true
	emit_signal("change_difficulty", difficulty)
	lastDifficultyButton = button

func set_languages():
	$Panel2/Language/HBoxContainer/spa.connect("pressed", self, "_on_language_button_pressed", [$Panel2/Language/HBoxContainer/spa])
	$Panel2/Language/HBoxContainer/eng.connect("pressed", self, "_on_language_button_pressed", [$Panel2/Language/HBoxContainer/eng])
	self.set_current_language()

func set_current_language():
	var controller = get_tree().get_current_scene()
	if controller.language == "es_AR":
		_on_language_button_pressed($Panel2/Language/HBoxContainer/spa)
	elif controller.language == "en_US":
		_on_language_button_pressed($Panel2/Language/HBoxContainer/eng)
	
func set_current_outline():
	var controller = get_tree().get_current_scene()
	$Panel3/Outline/CheckButton.pressed = controller.outline_items

func _on_CheckButton_pressed():
	var controller = get_tree().get_current_scene()
	controller.outline_items = !controller.outline_items

func _on_MusicHSlider_value_changed(value):
	var controller = get_tree().get_current_scene()
	controller.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Radio"), value)

func _on_SoundsHSlider_value_changed(value):
	var controller = get_tree().get_current_scene()
	controller.sounds_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), value)

func _on_VoicesHSlider_value_changed(value):
	var controller = get_tree().get_current_scene()
	controller.voices_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voices"), value)
	
func set_current_music_volume():
	var controller = get_tree().get_current_scene()
	$Panel4/MusicHSlider.value = controller.music_volume
	
func set_current_sounds_volume():
	var controller = get_tree().get_current_scene()
	$Panel5/SoundsHSlider.value = controller.sounds_volume
	
func set_current_voices_volume():
	var controller = get_tree().get_current_scene()
	$Panel6/VoicesHSlider.value = controller.voices_volume

func _on_language_button_pressed(button):
	if (lastLanguageButton):
		lastLanguageButton.disabled = false
	TranslationServer.set_locale(self.languages[button.text])
	var controller = get_tree().get_current_scene()
	controller._on_change_language(button.text)
	button.disabled = true
	lastLanguageButton = button

func _on_Settings_about_to_show():
	self.set_current_language()
	self.set_current_outline()
	self.set_current_music_volume()
	self.set_current_sounds_volume()
	self.set_current_voices_volume()

func disable_difficulty():
	$Panel/Difficulty.visible = false
	$Panel/cantdif.visible = true
	
func enable_difficulty():
	$Panel/Difficulty.visible = true
	$Panel/cantdif.visible = false
