extends Control
class_name ShopRodSlot

@onready var preview_rect: TextureRect = $preview
@onready var texture_rect: TextureRect = $texture

func _ready() -> void:
	preview_rect.visible = false

func set_texture(texture : Texture2D):
	texture_rect.texture = texture

func show_preview(value : bool = true):
	if preview_rect:
		preview_rect.visible = value
