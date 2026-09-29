extends Control


const BAIT_RATE_RANGE : Vector2 = Vector2(1, 2)

@onready var fishing_bar: FishingBar = %FishingBar
@onready var catch_progress_bar: CatchProgressBar = %CatchProgressBar
@onready var timer: Timer = $Timer
@onready var fish_group: Node2D = %FishGroup
@onready var progress_container: ProgressContainer = %ProgressContainer
@onready var audio_stream_player: SplashPlayer = $AudioStreamPlayer

@onready var background_day: TextureRect = $backgroundDay
@onready var background_night: TextureRect = $BackgroundNight
@onready var sun: TextureRect = $MarginContainer/VBoxContainer/MainScreen/HBoxContainer/MarginContainer/Control/NinePatchRect/ProgressContainer/Sun
@onready var moon: TextureRect = $MarginContainer/VBoxContainer/MainScreen/HBoxContainer/MarginContainer/Control/NinePatchRect/ProgressContainer/Moon

@onready var left: TextureRect = $MarginContainer/VBoxContainer/FishingBar/Left
@onready var right: TextureRect = $MarginContainer/VBoxContainer/FishingBar/Right
@onready var close: TextureButton = $tutorial/close

const BUTTON_DOWN = preload("res://Assets/textures/Button.png")
const BUTTON_UP = preload("res://Assets/textures/Button_up.png")

@onready var tutorial: Control = $tutorial

@onready var money_label: Label = %money_label
var total_money_today : int = 0
var displayed_money : int = 0 :
	set(value):
		displayed_money = value
		if money_label:
			money_label.text = str(value)

var day_ended : bool = false
var is_night : bool = false

var money_tween : Tween
var night_tween : Tween

var bait_timer_s : float = 0

var fish_getting_caught : Array[FishingFish] = []
var max_fishing_fish : int = 1

func _ready() -> void:
	if Globals.day_count == 1:
		process_mode = Node.PROCESS_MODE_DISABLED
		tutorial.show()
		await close.pressed
		process_mode = Node.PROCESS_MODE_INHERIT
	set_zone()
	background_night.visible = false
	timer.start(Globals.DAY_DURATION)
	bait_timer_s = randf_range(BAIT_RATE_RANGE.x, BAIT_RATE_RANGE.y)

func set_zone():
	match Globals.current_habitat:
		0:
			background_day.texture = load("res://Assets/textures/background_fishing_swamp.png")
			background_night.texture = load("res://Assets/textures/background_fishing_swamp_night.png")
			MainMusic.play_music(
				null, 
				load("res://Assets/music/greedyfishing_swamp.ogg"), 
				load("res://Assets/music/swampambience.ogg")
			)
		1:
			background_day.texture = load("res://Assets/textures/background_fishing_frozen.png")
			background_night.texture = load("res://Assets/textures/background_fishing_frozen_night.png")
			MainMusic.play_music(
				load("res://Assets/music/greedyfishing_snow_intro.ogg"), 
				load("res://Assets/music/greedyfishing_snow_loop.ogg"), 
				load("res://Assets/music/frozenambience.ogg")
			)
		2:
			background_day.texture = load("res://Assets/textures/background_fishing_volcano.png")
			background_night.texture = load("res://Assets/textures/background_fishing_volcano_night.png")
			MainMusic.play_music(
				load("res://Assets/music/greedyfishing_volcano_intro.ogg"),
				load("res://Assets/music/greedyfishing_volcano_loop.ogg"),
				load("res://Assets/music/volcanoambience.ogg")
			)

func _physics_process(delta: float) -> void:
	if not day_ended:
		update_day_timer()
		try_catch_fish(delta)
		if Input.is_action_just_pressed("left"):
			left.texture = BUTTON_DOWN
			SfxManager.play("fishstruggle%s" % randi_range(1, 2), 5.0, randf_range(0.75, 1.25))
		if Input.is_action_just_pressed("right"):
			right.texture = BUTTON_DOWN
			SfxManager.play("fishstruggle%s" % randi_range(1, 2), 5.0, randf_range(0.75, 1.25))
		if Input.is_action_just_released("left") :
			left.texture = BUTTON_UP
		if Input.is_action_just_released("right") :
			right.texture = BUTTON_UP

func try_catch_fish(delta : float):
	if fish_getting_caught.size() >= max_fishing_fish: return
	if bait_timer_s <= 0:
		bait_timer_s = randf_range(BAIT_RATE_RANGE.x, BAIT_RATE_RANGE.y)
		new_fish(FishManager.pick_a_fish())
	bait_timer_s -= delta

func new_fish(fish : FishResource):
	var new_fishing_fish : FishingFish = FishingFish.new(fishing_bar, fish)
	fish_getting_caught.append(new_fishing_fish)
	new_fishing_fish.catched.connect(catch.bind(new_fishing_fish))
	new_fishing_fish.fled.connect(snaped.bind(new_fishing_fish))
	fishing_bar.add_child(new_fishing_fish)
	new_fishing_fish.global_position = fishing_bar.absolute_center_position
	

func catch(fishing_fish : FishingFish):
	fish_getting_caught.erase(fishing_fish)
	fishing_fish.queue_free()
	var fish : FishResource = fishing_fish.current_fish
	if fish.rarity < 2:
		SfxManager.play("fishget_normal" , 5.0, randf_range(0.75, 1.25))
	elif fish.rarity < 3:
		SfxManager.play("fishget_rare" , 5.0, randf_range(0.75, 1.25))
	else:
		SfxManager.play("fishget_legendary" , 5.0, randf_range(0.75, 1.25))
	var bucket_preview : FishRigidBody = FishRigidBody.new(fish.texture)
	bucket_preview.position.x = randf_range(-100, 100)
	fish_group.add_child(bucket_preview)
	audio_stream_player.play_splash()
	total_money_today += int(fish.base_value)
	if money_tween:
		money_tween.kill()
	money_tween = create_tween()
	money_tween.tween_property(self, "displayed_money", total_money_today, 0.5)
	if not fish.seen:
		fish.seen = true
		Globals.unique_fish_caught += 1

func set_to_night():
	is_night = true
	if night_tween:
		night_tween.kill()
	night_tween = create_tween()
	night_tween.set_parallel()
	background_night.self_modulate = Color(1,1,1,1)
	background_night.visible = true
	moon.self_modulate = Color(1,1,1,0)
	moon.visible = true
	night_tween.tween_property(sun, "self_modulate", Color(1,1,1,0), 1.5).set_delay(1.5)
	night_tween.tween_property(moon, "self_modulate", Color(1,1,1,1), 1.5).set_delay(2.5)
	night_tween.tween_property(background_day, "self_modulate", Color(1,1,1,0), 5)
	
	


func update_day_timer():
	var progress : float = 1 - (timer.time_left/Globals.DAY_DURATION)
	progress_container.progress_ratio = progress
	if not is_night:
		if progress >= 0.5:
			set_to_night()
			
func snaped(fishing_fish : FishingFish):
	fish_getting_caught.erase(fishing_fish)
	fishing_fish.queue_free()
	SfxManager.play("fishfail")

func _on_timer_timeout() -> void:
	day_ended = true
	for fish in fish_getting_caught:
		fish.queue_free()
	Globals.day_count += 1
	Globals.money += total_money_today
	EventBus.day_ended.emit()
	Globals.rod.bait_gear = null
	Globals.rod.calculate_stats()
	await MainMusic.tune_music_down(-20, 1.5)
	SfxManager.play("endofday", 7)
	MainMusic.stop()
	await get_tree().create_timer(3).timeout
	
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind("res://Level Select/level_select.tscn"))


func _on_close_pressed() -> void:
	tutorial.hide()
