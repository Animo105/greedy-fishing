extends TextureRect
class_name FishOnBar

signal catched
signal fled

const FISH_BAR_BACK = preload("uid://dui466y1b0k5h")
const FISH_BAR_PROGRESS = preload("uid://ccnwom05alaul")
const COLOR_GREEN : Color = Color.GREEN
const COLOR_RED : Color = Color.RED

var progress_bar : ProgressBar = ProgressBar.new()

var current_fish : FishResource

static var fishing_bar : FishingBar

var normalised_position : float
var target_point : float
var max_catch_timer : float
var catch_time : float

var speed : float = 0

var tween : Tween

var is_inside_zone : bool = false :
	set(value):
		if value != is_inside_zone:
			is_inside_zone = value
			if is_inside_zone:
				progress_bar.modulate = COLOR_GREEN
			else:
				progress_bar.modulate = COLOR_RED

func _init(fish_resource : FishResource) -> void:
	current_fish = fish_resource
	texture = current_fish.texture if current_fish.seen else current_fish.hidden_texture
	scale = Vector2(0.5, 0.5)
	offset_transform_enabled = true
	# stats
	max_catch_timer = current_fish.catch_difficulty
	catch_time = max_catch_timer
	speed = current_fish.speed
	# make progress_bar
	progress_bar.show_percentage = false
	progress_bar.max_value = max_catch_timer
	progress_bar.min_value = 0
	progress_bar.anchor_right = 1
	progress_bar.set("theme_override_styles/background", FISH_BAR_BACK)
	progress_bar.set("theme_override_styles/fill", FISH_BAR_PROGRESS)
	add_child(progress_bar)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = fishing_bar.local_position_from_normalized(normalised_position)
	offset_transform_position = -size/2
	progress_bar.offset_top = -size.y/2
	is_inside_zone = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not fishing_bar : return
	position = fishing_bar.local_position_from_normalized(normalised_position)
	#update timer
	if is_inside_zone:
		catch_time = clamp(catch_time+delta, 0, max_catch_timer)
		if catch_time >= max_catch_timer:
			catched.emit()
	else:
		catch_time = clamp(catch_time-delta, 0, max_catch_timer)
		if catch_time <= 0:
			fled.emit()
	progress_bar.value = catch_time

func _physics_process(delta: float) -> void:
	is_inside_zone = fishing_bar.is_inside_zone(normalised_position)
	if normalised_position == target_point:
		target_point = randf_range(0, 1)
	normalised_position = move_toward(normalised_position, target_point, speed*delta)
