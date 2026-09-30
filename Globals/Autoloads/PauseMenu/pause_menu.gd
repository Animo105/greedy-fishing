extends CanvasLayer

var can_pause : bool = false
@onready var menu_container: PanelContainer = $MarginContainer/CenterContainer/MenuContainer
var tween : Tween

func _ready() -> void:
	visible = false

func open():
	menu_container.offset_transform_position = Vector2(0, get_window().size.y)
	visible = true
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(menu_container, "offset_transform_position", Vector2.ZERO, 0.2)

func close():
	menu_container.offset_transform_position = Vector2.ZERO
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(menu_container, "offset_transform_position", Vector2(0, get_window().size.y), 0.2)
	await tween.finished
	visible = false

func _on_resume_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_save_pressed() -> void:
	pass # Replace with function body.

func _on_title_screen_pressed() -> void:
	pass
