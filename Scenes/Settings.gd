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
	var time = controller.game_time
	$Panel/Difficulty/DifficultyMenuButton.text = self.difficulties[time]
	$Panel/Difficulty/DifficultyMenuButton.get_popup().add_item("$$easy")
	$Panel/Difficulty/DifficultyMenuButton.get_popup().add_item("$$medium")
	$Panel/Difficulty/DifficultyMenuButton.get_popup().add_item("$$hard")
	$Panel/Difficulty/DifficultyMenuButton.get_popup().connect("id_pressed", self, "_on_difficulty_pressed")

func _on_difficulty_pressed(id):
	var item_name = $Panel/Difficulty/DifficultyMenuButton.get_popup().get_item_text(id)
	var difficulty = self.difficulties[item_name]
	$Panel/Difficulty/DifficultyMenuButton.text = item_name
	emit_signal("change_difficulty", difficulty)

func set_languages():
	var controller = get_tree().get_current_scene()
	TranslationServer.set_locale(self.languages[controller.language])
	$Panel2/Language/LanguageMenuButton.text = controller.language
	$Panel2/Language/LanguageMenuButton.get_popup().add_item("$$spanish")
	$Panel2/Language/LanguageMenuButton.get_popup().add_item("$$english")
	$Panel2/Language/LanguageMenuButton.get_popup().connect("id_pressed", self, "_on_language_pressed")

func _on_language_pressed(id):
	var language = $Panel2/Language/LanguageMenuButton.get_popup().get_item_text(id)
	$Panel2/Language/LanguageMenuButton.text = language
	TranslationServer.set_locale(self.languages[language])
	var controller = get_tree().get_current_scene()
	controller._on_change_language(language)

func set_current_language():
	var controller = get_tree().get_current_scene()
	$Panel2/Language/LanguageMenuButton.text = controller.language

func _on_Settings_about_to_show():
	self.set_current_language()
	self.set_current_outline()
	self.set_current_music_volume()
	self.set_current_sounds_volume()
	self.set_current_voices_volume()

func _on_InGameSettings_about_to_show():
	self.set_current_language()
	self.set_current_outline()
	self.set_current_music_volume()
	self.set_current_sounds_volume()
	self.set_current_voices_volume()
	
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
