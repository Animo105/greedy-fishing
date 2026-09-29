extends Resource
class_name FishResource

enum Depth {
	ANY,
	SHALLOW,
	DEEP,
}

enum Bait{
	ANY,
	WORM,
	SHRIMP,
	OCTOPUS,
}

## Sprite du fish
@export var texture : Texture2D
## sprite caché du fish
@export var hidden_texture : Texture2D
## Temps de catch (seconde)
@export var catch_difficulty : float = 5
## recovery du timer de speed
@export var catch_recovery_speed : float = 1
## Vitesse de fuite du poisson (% seconde (1=100%))
@export var speed : float = 0.1
## Fréquence de changement de direction (chance every 5 frames)
@export var direction_change_frequency : float
## base sell_value
@export var base_value : float
## rarity of the fish
@export var rarity : float

##don't ask me
@export var bait_type : Bait
##don't ask me
@export var depth : Depth
##IDK
@export var habitat : int

var seen : bool = false
