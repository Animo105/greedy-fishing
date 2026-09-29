class_name StatBar
extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var texture_rect: TextureRect = $TextureRect


const STAT_BAR = preload("res://Assets/textures/StatBar.png")
const STAT_BAR_FULL = preload("res://Assets/textures/StatBar_full.png")


@export var icon : Texture2D 
@export var max_size : int = 3
var current_value : int

var bars : Array[TextureRect] = []

func _ready() -> void:
	texture_rect.texture = icon
	for i in range(0, max_size) :
		var bar = TextureRect.new()
		bar.texture = STAT_BAR
		bars.append(bar)
		h_box_container.add_child(bar)
		
		change_value(2)
		render_bar(3)

func change_value(new_value : int) -> void :
	current_value = new_value
	render_bar()
	
func render_bar(preview_value : int = -1) -> void :
	for index in bars.size() :
		if index < current_value :
			bars[index].texture = STAT_BAR_FULL
		else :
			bars[index].texture = STAT_BAR
