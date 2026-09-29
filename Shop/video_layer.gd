extends CanvasLayer
class_name StatsTuto

@onready var strenght: TextureRect = %Strenght
@onready var snap: TextureRect = %Snap
@onready var speed: TextureRect = %Speed


func _ready() -> void:
	hide()

func hide_all():
	strenght.visible = false
	snap.visible = false
	speed.visible = false

func show_strength():
	hide_all()
	strenght.show()
	show()

func show_speed():
	hide_all()
	speed.show()
	show()

func show_snap():
	hide_all()
	snap.show()
	show()


func _on_texture_button_pressed() -> void:
	visible = false
