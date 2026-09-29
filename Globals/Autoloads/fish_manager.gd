extends Node

const FISH_FOLDER_PATH = "res://Fish/Resources/"

var fish_list : Dictionary[String,FishResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_fish_from_folder(FISH_FOLDER_PATH)

func load_fish_from_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null: return
	
	for file in dir.get_files():
		var file_path := path.path_join(file)
		if ResourceLoader.exists(file_path):
			var fish_name := file.trim_suffix(".tres")
			var res = ResourceLoader.load(file_path)
			if res is FishResource:
				fish_list[fish_name] = res
	
	for folder in dir.get_directories():
		load_fish_from_folder(path.path_join(folder))

func pick_a_fish() -> FishResource:
	var can_pick : Array[FishResource] = []
	var current_bait_type : FishResource.Bait = Globals.rod.bait_type
	for fish : FishResource in fish_list.values():
		if fish.habitat != Globals.current_habitat:
			continue
		if fish.bait_type == FishResource.Bait.ANY or fish.bait_type == current_bait_type:
			can_pick.append(fish)
		
	var rng = RandomNumberGenerator.new()
	var weights : Array = []
	for fish : FishResource in can_pick:
		var weight : float = 1.0 / pow(abs(fish.rarity - Globals.rod.rarity) + 1.0, 2)
		weights.append(weight)
	return can_pick[rng.rand_weighted(weights)]
