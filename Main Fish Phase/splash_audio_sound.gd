extends AudioStreamPlayer
class_name SplashPlayer

var splash_sound : Array

func _ready() -> void:
	var sound1 := load("res://Assets/SFX/splash.ogg")
	var sound2 := load("res://Assets/SFX/splash2.ogg")
	var sound3 := load("res://Assets/SFX/splash3.ogg")
	splash_sound.append(sound1)
	splash_sound.append(sound2)
	splash_sound.append(sound3)

func play_splash():
	stream = splash_sound.pick_random()
	play()
