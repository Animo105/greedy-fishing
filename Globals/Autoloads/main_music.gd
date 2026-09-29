extends Node

var music_player : AudioStreamPlayer = AudioStreamPlayer.new()
var ambience_player : AudioStreamPlayer = AudioStreamPlayer.new()

var lake_ambience : AudioStream
var tween : Tween
func _ready() -> void:
	lake_ambience = load("res://Assets/music/lakeambience.ogg")
	add_child(music_player)
	add_child(ambience_player)

func tune_music_down(volume : float, time: float):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(music_player, "volume_db", volume, time)
	tween.tween_property(ambience_player, "volume_db", volume, time)
	await tween.finished
	print(music_player.volume_db)

func play_music(intro : AudioStream = null, loop : AudioStream = null, ambience : AudioStream = null):
	if tween:
		tween.kill()
	music_player.volume_db = 0
	ambience_player.volume_db = 0
	if ambience:
		ambience_player.stream = ambience
		ambience_player.play()
	if intro:
		music_player.stream = intro
		music_player.play()
		await music_player.finished
	if loop:
		music_player.stream = loop
		music_player.play()

func stop():
	music_player.stop()
	ambience_player.stop()

func play_lake_ambience():
	ambience_player.stream = lake_ambience
	ambience_player.play()
