class_name BaitBucket
extends Control

signal pressed(bucket :BaitBucket)

@export var frames: Array[Texture2D] = []
@export var setup_gear: GearResource

var frame_index: int = 0

@onready var texture_rect: TextureRect = $TextureRect
@onready var tag: PriceTag = $TextureRect/Tag

func _ready() -> void:
	texture_rect.texture = frames[0]
	tag.setup(setup_gear)
	
	var timer := Timer.new()
	timer.wait_time = 0.3
	timer.timeout.connect(func():
		texture_rect.texture = frames[frame_index]
		frame_index = 1 if frame_index == 0 else 0
	)
	add_child(timer)
	timer.start()

func _on_mouse_entered() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(texture_rect, "position", Vector2(0,-10), 0.15)


func _on_mouse_exited() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(texture_rect, "position", Vector2.ZERO, 0.15)


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		pressed.emit(self)
