extends Sprite2D
class_name FishingFish

signal catched
signal fled

const FISHING_FISH_PROGRESS_BAR = preload("uid://c010r347bfa83")
const FISHING_FISH_PROGRESS_BAR_PROGRESS = preload("uid://cdutsjatg4k0y")
const FISH_BAR_BACK = preload("uid://dui466y1b0k5h")
const FISH_BAR_PROGRESS = preload("uid://ccnwom05alaul")
const COLOR_GREEN : Color = Color.GREEN
const COLOR_RED : Color = Color.RED

const FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN : int = 5
const MINIMAL_SNAP_STRENGHT_s : float = 3

var fishing_bar : FishingBar = null

var current_fish : FishResource = null
var max_catch_timer : float = 0
var catch_timer_s : float = 0
var catch_recovery_s : float = 0
var fish_speed : float = 0
var fish_direction : float = 0
var frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN
var is_inside_zone : bool = false
var tween : Tween

var progress_bar : ProgressBar = ProgressBar.new()

func _init(fishingbar : FishingBar, fish : FishResource) -> void:
	scale = Vector2(0.5, 0.5)
	fishing_bar = fishingbar
	current_fish = fish
	texture = fish.texture if fish.seen else fish.hidden_texture
	visible = true
	max_catch_timer = clamp(fish.catch_difficulty - Globals.rod.catch_speed, Globals.MIN_CATCH_TIME, Globals.MAX_CATCH_TIME)
	catch_timer_s = max_catch_timer * 0.8
	catch_recovery_s = clamp(current_fish.catch_recovery_speed - Globals.rod.snap_resistence, Globals.MIN_SNAP_SPEED, Globals.MAX_SNAP_SPEED)
	fish_speed = clamp(fish.speed - (Globals.rod.pull_strenght/10.0), Globals.MIN_FISH_SPEED, Globals.MAX_FISH_SPEED)
	fish_direction = 1 if randf() < 0.5 else -1
	flip_h = fish_direction < 0
	global_position.x = randf_range(fishing_bar.leftmost_x_position, fishing_bar.rightmost_x_position)
	global_position.y = fishing_bar.absolute_center_position.y
	# make progress_bar
	progress_bar.show_percentage = false
	progress_bar.max_value = 1
	progress_bar.min_value = 0
	progress_bar.offset_left = -192
	progress_bar.offset_top = -188
	progress_bar.set("theme_override_styles/background", FISH_BAR_BACK)
	progress_bar.set("theme_override_styles/fill", FISH_BAR_PROGRESS)
	progress_bar.custom_minimum_size = Vector2(384, 50)
	progress_bar.custom_maximum_size = Vector2(384, 50)
	add_child(progress_bar)

func _physics_process(delta: float) -> void:
	if not current_fish: return # pas de fish a reel
	var new_x = global_position.x + (fishing_bar.get_amount_px_for_speed(fish_speed) * fish_direction * delta)
	frame_countdown -= 1
	if frame_countdown <= 0:
		if randf() < current_fish.direction_change_frequency:
			fish_direction *= -1
			flip_h = fish_direction < 0
		frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN
	# do reeling
	if Input.is_action_just_pressed("left"):
		new_x -= fishing_bar.pull_amount_px
	if Input.is_action_just_pressed("right"):
		new_x += fishing_bar.pull_amount_px
	# move fish
	global_position.x = clamp(new_x, fishing_bar.leftmost_x_position, fishing_bar.rightmost_x_position)
	#fish_sprite.global_position.y = fishing_bar.absolute_center_position.y
	# do catch or break cycle
	# ##### a changer ##### #
	var new_is_inside_zone :bool = fishing_bar.is_inside_zone(global_position.x)
	if new_is_inside_zone != is_inside_zone:
		is_inside_zone = new_is_inside_zone
		if tween:
			tween.kill()
		scale = Vector2(0.5,0.5)
		if is_inside_zone:
			tween = create_tween()
			tween.set_loops()
			tween.tween_property(self, "scale", Vector2(0.48,0.48), 0.05)
			tween.tween_property(self,"scale", Vector2(0.5,0.5), 0.05)
	# ###################### #
	if is_inside_zone:
		progress_bar.self_modulate = COLOR_GREEN
		catch_timer_s -= delta
		if catch_timer_s <= 0:
			catch()
	else:
		progress_bar.self_modulate = COLOR_RED
		catch_timer_s = clamp(catch_timer_s + catch_recovery_s * delta, 0, max_catch_timer)
		if catch_timer_s == max_catch_timer:
			snap()
	# update catch bar
	progress_bar.value = (1-(catch_timer_s/max_catch_timer))

func catch():
	catched.emit()

func snap():
	fled.emit()
