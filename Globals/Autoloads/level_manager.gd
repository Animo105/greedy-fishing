extends Node

const LEVEL_FOLDER_PATH = "res://Level Select/Level ressources/"

var level_list : Dictionary[int,LevelRessource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(LEVEL_FOLDER_PATH):
		if ResourceLoader.exists(LEVEL_FOLDER_PATH + file):
			var res = ResourceLoader.load(LEVEL_FOLDER_PATH + file)
			if res is LevelRessource:
				level_list[res.id] = res
	level_list[0].is_unlocked = true
