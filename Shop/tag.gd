class_name PriceTag
extends Control

@onready var tag: TextureRect = $Tag
@onready var price: Label = $Tag/Price

@onready var tag_big: TextureRect = $TagBig
@onready var price_big: Label = $TagBig/PriceBig

@onready var tag_small: TextureRect = $TagSmall
@onready var price_small: Label = $TagSmall/PriceSmall

var active_tag: TextureRect

func setup(setup_gear: GearResource) -> void:
	tag.hide()
	tag_big.hide()
	tag_small.hide()
	
	var price_string := str(setup_gear.price)
	match price_string.length():
		1, 2:
			active_tag = tag_small
		3:
			active_tag = tag
		_:
			active_tag = tag_big
			
	active_tag.show()
	var price_tag = active_tag.get_child(0)
	price_tag.text = "%d$" % setup_gear.price

func rotate_tag(tween: Tween, rotation: float) -> void:
	tween.tween_property(active_tag, "rotation", rotation, 0.15)

func sold():
	var new_price = active_tag.get_child(0)
	new_price.text = "sold"
	new_price.add_theme_color_override("font_color", "FF0000")
