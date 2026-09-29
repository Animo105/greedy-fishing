extends PanelContainer
class_name FishingBar

const CATCH_ZONE_SIZE : float = 0.10

@onready var center_bar: TextureRect = $Control/CenterBar


var leftmost_x_position : float :
	get(): return global_position.x + 50
var rightmost_x_position : float :
	get(): return global_position.x + size.x - 50
var absolute_center_position : Vector2 :
	get(): return Vector2(global_position.x+(size.x/2), global_position.y+(size.y/2))
var pull_amount_px : float :
	get(): return size.x * Globals.PULL_FORCE_PERCENT

func _ready() -> void:
	center_bar.anchor_left = 0.5-CATCH_ZONE_SIZE/2
	center_bar.anchor_right = 0.5+CATCH_ZONE_SIZE/2

func get_amount_px_for_speed(speed : float)->float:
	return size.x * speed

func get_distance_from_center_in_percent(x : float)-> float:
	return abs(x - absolute_center_position.x) / (rightmost_x_position - leftmost_x_position)

func is_inside_zone(x : float) -> bool:
	var distance = get_distance_from_center_in_percent(x)
	return distance < (CATCH_ZONE_SIZE + 0.05)/2
