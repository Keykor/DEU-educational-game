extends Control

var current_animation = 0
var animations = ["cat","placa_roja","news_start","person_talk"]

func next_animation():
	$AnimationPlayer.play(animations[current_animation])
	current_animation = current_animation + 1

func _ready():
	next_animation()

func _on_Button_pressed():
	if (current_animation >= 4):
		queue_free()
		get_parent().active_scene.show()
		return
	next_animation()

func start_audio(name):
	var language = get_parent().language
	if language == "$$spanish":
		$Voices.stream = load("res://Assets/Voices/"+ name +"_esp.wav")
	elif language == "$$english":
		$Voices.stream = load("res://Assets/Voices/"+ name +"_eng.wav")
	$Voices.play()

func news_dialog_audio():
	start_audio("news_dialog")

func news_extended_title_audio():
	start_audio("news_extended_title")
	
func person_intro_audio():
	start_audio("person_intro")
