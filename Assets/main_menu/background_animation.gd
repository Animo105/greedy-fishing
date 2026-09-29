extends Control

@onready var sunset: TextureRect = $Sunset
@onready var boat: TextureRect = $Boat
@onready var sea: TextureRect = $Sea
@onready var palm: TextureRect = $Palm
@onready var fish: TextureRect = $Fish
@onready var play: TextureRect = $Boat/Play
@onready var quit: TextureRect = $Palm/Quit


const SPLASH = preload("res://Assets/main_menu/splash.png")

var has_fish := true
var time := 0.0
var is_hovered := false

func _ready() -> void:
	play.modulate = Color.PALE_GREEN
	quit.scale = Vector2.ONE * 0.46

func _process(delta):
	time += delta
	
	boat.position.y = sin(time * 2.0) * 15.0 + 30
	boat.rotation = sin(time * 2.0) * 0.05
	sea.position.y = sin(time * 2.0) * 15.0 + 22
	
	if has_fish :
		fish.rotation += delta * -2
	
	quit.rotation = sin(time * -2.0) * 0.025
	play.scale = Vector2.ONE * (1.0 + sin(time * 5.0) * 0.05)

func _on_play_mouse_entered() -> void:
	play.modulate = Color.GREEN
	SfxManager.play("buttonhover2", -2, randf_range(0.75, 1.25))

func _on_play_mouse_exited() -> void:
	play.modulate = Color.PALE_GREEN

func _on_fish_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		SfxManager.play("fishget_legendary", 1.0)
		Globals.day_count = 69
		Globals.money = 99999
		Globals.unique_fish_caught = 999
		fish.texture = SPLASH
		has_fish = false
		
func _on_quit_mouse_entered() -> void:
	quit.scale = Vector2.ONE * 0.48
	SfxManager.play("buttonhover2", -2, randf_range(0.75, 1.25))


func _on_quit_mouse_exited() -> void:
	quit.scale = Vector2.ONE * 0.46
