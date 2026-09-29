extends Resource
class_name LevelRessource

## Sprite du fish
@export var texture : Texture2D
## sprite caché du fish
@export var hidden_texture : Texture2D
@export var id : int
@export var cost : int
var is_unlocked : bool = false

@export var shop_frames: Array[Texture2D] = []
