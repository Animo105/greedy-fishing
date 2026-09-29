extends Control

@onready var grid_container: GridContainer = $GridContainer

var slot_scene = preload("res://Shop/Slot.tscn")

@onready var texture_rect: TextureRect = $TextureRect

@onready var line: ShopRodSlot = $Equipment/VBoxContainer2/Line
@onready var spoon: ShopRodSlot = $Equipment/VBoxContainer2/Spoon
@onready var hook: ShopRodSlot = $Equipment/VBoxContainer2/Hook
@onready var bait: ShopRodSlot = $Equipment/VBoxContainer2/Bait

@onready var bait_bucket: BaitBucket = $Baits/BaitBucket
@onready var bait_bucket_2: BaitBucket = $Baits/BaitBucket2
@onready var bait_bucket_3: BaitBucket = $Baits/BaitBucket3

@onready var strength: SkillBar = $Equipment/VBoxContainer/Strength
@onready var snap: SkillBar = $Equipment/VBoxContainer/Snap
@onready var speed: SkillBar = $Equipment/VBoxContainer/Speed
@onready var rarity: SkillBar = $Equipment/VBoxContainer/Rarity

@onready var video_layer: StatsTuto = $VideoLayer

@onready var money_label: Label = %MoneyLabel

var frames: Array[Texture2D] = []
var frame_index: int = 0

func _set_animation():
	var level = LevelManager.level_list[Globals.current_habitat]
	frames = level.shop_frames
	if frames == []: return
	var timer := Timer.new()
	timer.wait_time = 0.5
	texture_rect.texture = frames[0]
	timer.timeout.connect(func():
		frame_index = (frame_index + 1) % frames.size()
		texture_rect.texture = frames[frame_index]
	)
	add_child(timer)
	timer.start()

func _ready():
	var intro : AudioStream = load("res://Assets/music/greedyfishing_bossanova_intro.ogg")
	var loop : AudioStream = load("res://Assets/music/greedyfishing_bossanova_loop.ogg")
	MainMusic.play_music(intro, loop)
	_set_animation()
	money_label.text = "%.f$" % Globals.money
	set_actives_slots()
	if Globals.rod.bait_gear:
		bait.set_texture(Globals.rod.bait_gear.texture)
	if Globals.rod.spoon_gear:
		spoon.set_texture(Globals.rod.spoon_gear.texture)
	if Globals.rod.line_gear:
		line.set_texture(Globals.rod.line_gear.texture)
	if Globals.rod.hook_gear:
		hook.set_texture(Globals.rod.hook_gear.texture)
	
	# pick stuff
	var hooks : Array = GearManager.hook_list.duplicate()
	hooks.sort_custom(func(a : GearResource, b : GearResource): return a.price < b.price)
	for gear : GearResource in hooks:
		if gear.in_shop == Globals.current_habitat:
			create_slot(gear)
	var spoons : Array = GearManager.spoon_list.duplicate()
	spoons.sort_custom(func(a : GearResource, b : GearResource): return a.price < b.price)
	for gear : GearResource in spoons:
		if gear.in_shop == Globals.current_habitat:
			create_slot(gear)
	var lines : Array = GearManager.line_list.duplicate()
	lines.sort_custom(func(a : GearResource, b : GearResource): return a.price < b.price)
	for gear : GearResource in lines:
		if gear.in_shop == Globals.current_habitat:
			create_slot(gear)

	for bucket : BaitBucket in [bait_bucket, bait_bucket_2, bait_bucket_3]:
		bucket.pressed.connect(bucket_clicked)
		bucket.mouse_entered.connect(bait_hover.bind(bucket.setup_gear))
		bucket.mouse_exited.connect(bait_unhover)

func create_slot(gear : GearResource):
	var slot : Slot = slot_scene.instantiate()
	slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	slot.pressed.connect(slot_clicked)
	slot.on_mouse_entered.connect(slot_enter_hover)
	slot.on_mouse_exited.connect(slot_exit_hover)
	grid_container.add_child(slot)
	slot.setup(gear)

func bucket_clicked(bucket: BaitBucket) :
	if buy_and_set(bucket.setup_gear):
		set_actives_slots()
		hide_gear_preview()

func bait_hover(gear : GearResource):
	preview_gear(gear)
	bait.show_preview()

func bait_unhover():
	hide_gear_preview()
	bait.show_preview(false)

func slot_clicked(slot: Slot) -> void :
	if buy_and_set(slot.gear):
		set_actives_slots()
		hide_gear_preview()
		grid_container.remove_child(slot)

func preview_gear(gear : GearResource):
	var temp_rod : Rod = Globals.rod.duplicate()
	temp_rod.swap_gear(gear)
	temp_rod.calculate_stats()
	strength.preview_value = temp_rod.pull_strenght
	speed.preview_value = temp_rod.catch_speed
	snap.preview_value = temp_rod.snap_resistence
	rarity.preview_value = temp_rod.rarity

func slot_enter_hover(slot: Slot) -> void :
	preview_gear(slot.gear)
	match slot.gear.type:
		GearResource.Type.BAIT :
			bait.show_preview()
		GearResource.Type.SPOON :
			spoon.show_preview()
		GearResource.Type.LINE :
			line.show_preview()
		GearResource.Type.HOOK :
			hook.show_preview()

func hide_gear_preview():
	strength.hide_preview()
	snap.hide_preview()
	speed.hide_preview()
	rarity.hide_preview()
	line.show_preview(false)
	spoon.show_preview(false)
	hook.show_preview(false)
	bait.show_preview(false)

func slot_exit_hover(_slot: Slot) -> void :
	hide_gear_preview()


func buy_and_set(gear : GearResource) -> bool:
	var gear_price = gear.price
	if Globals.money < gear_price :
		return false
	Globals.money -= gear_price
	money_label.text = "%.f" % Globals.money
	SfxManager.play("cashregisternoise", -5)
	match gear.type :
		GearResource.Type.BAIT :
			Globals.rod.bait_gear = gear
			bait.set_texture(gear.texture)
		GearResource.Type.SPOON :
			Globals.rod.spoon_gear = gear
			spoon.set_texture(gear.texture)
		GearResource.Type.LINE :
			Globals.rod.line_gear = gear
			line.set_texture(gear.texture)
		GearResource.Type.HOOK :
			Globals.rod.hook_gear = gear
			hook.set_texture(gear.texture)
	return true

func set_actives_slots():
	Globals.rod.calculate_stats()
	strength.actual_value = Globals.rod.pull_strenght
	speed.actual_value = Globals.rod.catch_speed
	snap.actual_value = Globals.rod.snap_resistence
	rarity.actual_value = Globals.rod.rarity
	

func _on_next_button_pressed() -> void:
	Globals.rod.calculate_stats()
	MainMusic.stop()
	SfxManager.play("buttonclick_generic")
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind("res://Main Fish Phase/main_fish_phase.tscn"))


func _on_strength_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		video_layer.show_strength()


func _on_snap_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		video_layer.show_snap()


func _on_speed_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		video_layer.show_speed()
