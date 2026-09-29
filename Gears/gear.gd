extends Resource
class_name GearResource

enum Type {
	HOOK,
	SPOON,
	LINE,
	BAIT,
}

@export var type : Type
@export var price : int
@export var texture : Texture2D
@export_range(0, 2, 1) var level : int
## représente un % de la bar. fish_speed = fish_speed - (strenght/10.0)
@export var strenght : float
## duré de catch. catch_time = fish_catch - speed
@export var speed : float
## affecte recovery du poisson. catch_time = catch_time + (fish_recovery - snap) [a un min et max]
@export var snap : float
## La rarity est mesurer de 0 à 5 et change les poissons hooked
@export var rarity : float

@export_range(0, 2, 1) var in_shop : int
