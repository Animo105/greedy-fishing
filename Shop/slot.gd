class_name Slot
extends Control

signal pressed(slot)
signal on_mouse_entered(slot)
signal on_mouse_exited(slot)

@onready var item: TextureRect = $Item
@onready var shadow: TextureRect = $Shadow
@onready var tag: PriceTag = $Tag

var gear : GearResource

func sold() -> void:
	tag.sold()

func setup(setup_gear: GearResource) -> void:
	gear = setup_gear
	item.texture = gear.texture
	tag.setup(setup_gear)

func _process(delta: float) -> void:
	var value = sin(Time.get_ticks_msec() * 0.0015)
	item.position.y = value * 5.0
	
	value = value * 0.1 + 0.8
	shadow.scale = Vector2(value, value)


func _on_mouse_entered() -> void:
	on_mouse_entered.emit(self)
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", deg_to_rad(-55), 0.15)
	tag.rotate_tag(tween, deg_to_rad(-7))

func _on_mouse_exited() -> void:	
	on_mouse_exited.emit(self)
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", deg_to_rad(-45), 0.15)
	tag.rotate_tag(tween, deg_to_rad(0))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		pressed.emit(self)
		
