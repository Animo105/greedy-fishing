extends Control

@onready var sprite_layer: Node2D = $SpriteLayer
@onready var fish_display: HFlowContainer = $FishDisplay
@onready var left: TextureButton = $MarginContainer/HBoxContainer/Left
@onready var select_button: TextureButton = $MarginContainer/HBoxContainer/SelectButton
@onready var unlock_button: TextureButton = $MarginContainer/HBoxContainer/UnlockButton
@onready var right: TextureButton = $MarginContainer/HBoxContainer/Right
@onready var center_marker: Control = $CenterMarker
@onready var price: Label = $MarginContainer/HBoxContainer/UnlockButton/price
@onready var day_number: Label = $Callendar/DayNumber


var stages: Array
var stage_tween : Tween
var fish_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainMusic.play_music(load("res://Assets/music/greedyfishing_menu_intro.ogg"), load("res://Assets/music/greedyfishing_menu_loop.ogg"), load("res://Assets/music/lakeambience.ogg"))
	updates_buttons()
	display_fishes()
	day_number.text = str(Globals.day_count)
	var values : = LevelManager.level_list.values()
	values.sort_custom(
		func(a : LevelRessource, b : LevelRessource) -> bool:
			return a.id < b.id
	)
	for level : LevelRessource in values:
		var level_sprite : Sprite2D = Sprite2D.new()
		level_sprite.texture = level.texture if level.is_unlocked else level.hidden_texture
		level_sprite.global_position.x = center_marker.global_position.x if level.id == Globals.current_habitat else center_marker.global_position.x * (-1.5 if level.id < Globals.current_habitat else 3)
		level_sprite.global_position.y = center_marker.global_position.y
		stages.append(level_sprite)
		sprite_layer.add_child(level_sprite)

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		_on_left_pressed()
	if event.is_action_pressed("right"):
		_on_button_2_pressed()

func _on_left_pressed() -> void:
	if Globals.current_habitat != 0:
		if stage_tween:
			if stage_tween.is_running():
				finish_tween()
			stage_tween.kill()
		stage_tween = create_tween()
		stage_tween.set_parallel()
		stage_tween.set_trans(Tween.TRANS_BACK)
		stage_tween.set_ease(Tween.EASE_OUT)
		stage_tween.tween_property(stages[Globals.current_habitat], "position:x", center_marker.position.x * 3, 2.0)
		stage_tween.tween_property(stages[Globals.current_habitat-1], "position:x", center_marker.position.x, 2.5)
		Globals.current_habitat -= 1
		SfxManager.play("rowing%s" % randi_range(1, 4))
		updates_buttons()
		display_fishes()
		print(center_marker.global_position)
	print(Globals.current_habitat)

func _on_button_2_pressed() -> void:
	if Globals.current_habitat != stages.size()-1:
		if stage_tween:
			if stage_tween.is_running():
				finish_tween()
			else:
				stage_tween.kill()
		stage_tween = create_tween()
		stage_tween.set_parallel()
		stage_tween.set_trans(Tween.TRANS_BACK)
		stage_tween.set_ease(Tween.EASE_OUT)
		stage_tween.tween_property(stages[Globals.current_habitat], "position:x", center_marker.position.x * -1.5, 2.5)
		stage_tween.tween_property(stages[Globals.current_habitat+1], "position:x", center_marker.position.x, 2.0)
		Globals.current_habitat += 1
		SfxManager.play("rowing%s" % randi_range(1, 4))
		updates_buttons()
		display_fishes()


func _on_select_pressed() -> void:
	if !LevelManager.level_list[Globals.current_habitat].is_unlocked: return
	MainMusic.tune_music_down(-25, 2)
	SfxManager.play("enterarea", -2)
	stage_tween = create_tween()
	stage_tween.tween_property(stages[Globals.current_habitat], "scale", Vector2(10.0, 10.0), 1.0)
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind("res://Shop/shop.tscn"))

func _on_unlock_button_pressed() -> void:
	if LevelManager.level_list[Globals.current_habitat].is_unlocked: return
	if LevelManager.level_list[Globals.current_habitat].cost < Globals.money:
		Globals.money -= LevelManager.level_list[Globals.current_habitat].cost
		SfxManager.play("lockopening")
		LevelManager.level_list[Globals.current_habitat].is_unlocked = true
		stages[Globals.current_habitat].texture = LevelManager.level_list[Globals.current_habitat].texture
		select_button.visible = true
		unlock_button.visible = false


func display_fishes() -> void:
	for child in fish_display.get_children():
		fish_display.remove_child(child)
	for x : FishResource in FishManager.fish_list.values():
		if x.habitat == Globals.current_habitat:
			var fish_display_texture : TextureRect = TextureRect.new()
			fish_display_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			if x.seen:
				fish_display_texture.texture = x.texture
			else:
				fish_display_texture.texture = x.hidden_texture
			fish_display_texture.custom_minimum_size = Vector2(64,64)
			fish_display.add_child(fish_display_texture)
	fish_display.position = Vector2(0, -500)
	if fish_tween:
		fish_tween.kill()
	fish_tween = create_tween()
	fish_tween.set_trans(Tween.TRANS_BACK)
	fish_tween.set_ease(Tween.EASE_OUT)
	fish_tween.tween_property(fish_display, "position:y", 50, 2.0)

func finish_tween():
	if stage_tween:
		stage_tween.kill()
	if Globals.current_habitat > 0:
		stages[Globals.current_habitat-1].position.x = center_marker.position.x * -1.5
	if Globals.current_habitat < stages.size() -1:
		stages[Globals.current_habitat+1].position.x = center_marker.position.x * 3
	if fish_tween:
		fish_tween.kill()
	fish_display.position = Vector2(0, -500)
		
	

func updates_buttons():
	left.disabled = Globals.current_habitat == 0
	right.disabled = Globals.current_habitat == stages.size()-1
	if LevelManager.level_list[Globals.current_habitat].is_unlocked:
		price.visible = false
		select_button.visible = true
		unlock_button.visible = false
	else:
		if LevelManager.level_list[Globals.current_habitat].cost-Globals.unique_fish_caught < 0:
			price.text = "0"
		else:
			price.text = str(LevelManager.level_list[Globals.current_habitat].cost-Globals.unique_fish_caught)
		price.visible = true
		unlock_button.visible = true
		select_button.visible = false
		unlock_button.disabled = LevelManager.level_list[Globals.current_habitat].cost > Globals.unique_fish_caught


func _on_resized() -> void:
	for i in stages.size():
		stages[i].global_position.x = center_marker.global_position.x if i == Globals.current_habitat else center_marker.global_position.x * (-1.5 if i < Globals.current_habitat else 3)
		stages[i].global_position.y = center_marker.global_position.y


func _on_mouse_entered() -> void:
	SfxManager.play("buttonhover2", randf_range(0.75, 1.25))
