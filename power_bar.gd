class_name PowerBar
extends Control

@export_range(1, 5) var slots: int = 1:
	set(value):
		slots = value
		if is_node_ready():
			_update_size()
			queue_redraw()


@export_range(0, 5) var active_slots: int = 0:
	set(value):
		active_slots = value
		queue_redraw()

@export_range(0, 5) var preview_slots: int = 0:
	set(value):
		preview_slots = value
		queue_redraw()

@export_group("Texture", "texture_")
@export var texture_empty: Texture2D
@export var texture_filled: Texture2D
@export var texture_icon: Texture2D

@export_group("Size")
@export var icon_size: Vector2 = Vector2(64, 64)

const GAP_SIZE := 5


func _ready() -> void:
	_update_size()
	queue_redraw()


func _update_size() -> void:

	var bar_size := texture_empty.get_size()

	var total_width := icon_size.x + GAP_SIZE + slots * bar_size.x + (slots - 1) * GAP_SIZE
	var total_height := maxf(icon_size.y, bar_size.y)

	custom_minimum_size = Vector2(total_width, total_height)


func _draw() -> void:
	if not texture_empty or not texture_icon:
		return

	var bar_size := texture_empty.get_size()
	var total_height := maxf(icon_size.y, bar_size.y)

	var icon_position := Vector2(
		0,
		(total_height - icon_size.y) / 2.0
	)

	var icon_rect := Rect2(icon_position, icon_size)
	draw_texture_rect(texture_icon, icon_rect, false)

	var bar_start_x := icon_size.x + GAP_SIZE

	for i in range(slots):
		var x := bar_start_x + i * (bar_size.x + GAP_SIZE)

		if active_slots > i:
			draw_texture(
				texture_filled,
				Vector2(x, (total_height - bar_size.y) / 2.0),
				Color.DODGER_BLUE
			)
		else:
			draw_texture(
				texture_empty,
				Vector2(x, (total_height - bar_size.y) / 2.0)
			)

		if preview_slots > i:
			var preview_rect_src := Rect2(
				Vector2(0, (bar_size.y) / 2.0),
				Vector2(
					bar_size.x,
					(bar_size.y) / 2.0
				)
			)

			var preview_position := Vector2(
				Vector2(x, (total_height) / 2.0)
			)

			var preview_rect_target := Rect2(
				preview_position,
				preview_rect_src.size
			)

			draw_texture_rect_region(
				texture_filled,
				preview_rect_target,
				preview_rect_src,
				Color.SPRING_GREEN
			)
