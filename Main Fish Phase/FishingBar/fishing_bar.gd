extends PanelContainer
class_name FishingBar

const INNER_BAR_PADDING : float = 50
const CATCH_ZONE_ERROR_MARGIN : float = 0.05

var catch_zone_size : float = 0.1
var catch_zone_max_speed : float = 0.1
var catch_zone_accel : float = 0.1
var catch_zone_decel : float = 0.1
var catch_zone_position : float = 0.5

var catch_zone_speed : float = 0.0

@onready var bar_container: Control = $MarginContainer/BarContainer
@onready var catch_zone: NinePatchRect = %CatchZone

var do_player_inputs : bool = true

var leftmost_x_position : float :
	get(): return bar_container.global_position.x + INNER_BAR_PADDING
var rightmost_x_position : float :
	get(): return bar_container.global_position.x + bar_container.size.x - INNER_BAR_PADDING
var absolute_center_position : Vector2 :
	get(): return Vector2(bar_container.global_position.x+(bar_container.size.x/2), global_position.y+(bar_container.size.y/2))

func _ready() -> void:
	catch_zone_position = 0.5
	FishOnBar.fishing_bar = self
	update_catch_zone()

func update_catch_zone():
	catch_zone.anchor_left = catch_zone_position - catch_zone_size/2
	catch_zone.anchor_right = catch_zone_position + catch_zone_size/2

func move_catch_zone(delta : float):
	var input : float = 0
	if do_player_inputs:
		input = Input.get_axis("left", "right")
	if input != 0:
		catch_zone_speed = move_toward(catch_zone_speed, input * catch_zone_max_speed, catch_zone_accel * delta)
	else:
		catch_zone_speed = move_toward(catch_zone_speed, 0, catch_zone_decel * delta)
	var new_catch_zone_pos = clamp(catch_zone_position+catch_zone_speed, 0+catch_zone_size/2, 1-catch_zone_size/2)
	catch_zone_speed = new_catch_zone_pos - catch_zone_position
	catch_zone_position = new_catch_zone_pos
	update_catch_zone()

func _physics_process(delta: float) -> void:
	move_catch_zone(delta)
	

func add_fish(fish : FishResource) -> FishOnBar:
	var f : FishOnBar = FishOnBar.new(fish)
	bar_container.add_child(f)
	return f

func local_position_from_normalized(x : float)-> Vector2:
	return Vector2(lerp(0.0, size.x, x), size.y/2)

func is_inside_zone(x : float) -> bool:
	return x >= catch_zone_position-(CATCH_ZONE_ERROR_MARGIN+catch_zone_size/2) and x  <= catch_zone_position+(CATCH_ZONE_ERROR_MARGIN+catch_zone_size/2)
