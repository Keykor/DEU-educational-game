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
		return
	next_animation()
