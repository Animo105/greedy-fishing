extends Node

const POOL_SIZE := 16
const SFX_PATH : String = "res://Assets/SFX/"

var players: Array[AudioStreamPlayer] = []
@export var sfxs : Dictionary[String, AudioStream] = {}


func _ready() -> void:
	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		players.append(player)
	for file in DirAccess.get_files_at(SFX_PATH):
		continue
		if ResourceLoader.exists(SFX_PATH + file):
			var res = load(SFX_PATH + file)
			if res is AudioStream:
				var sfx_name : String = file.trim_suffix(".ogg")
				sfxs[sfx_name] = res

func play(sfx : String, volume_db := 0.0, pitch_scale := 1.0):
	if sfxs.has(sfx):
		play_stream(sfxs[sfx], volume_db, pitch_scale)

func stop_all():
	for player in players:
		player.stop()

func play_stream(stream: AudioStream, volume_db := 0.0, pitch_scale := 1.0) -> void:
	var player := _get_free_player()
	if player == null: return
	
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func _get_free_player() -> AudioStreamPlayer:
	for player in players:
		if not player.playing:
			return player
	return null
