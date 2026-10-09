extends Node

const FISH_FOLDER_PATH = "res://Fish/Resources/"

const FISH_LIBRARY = preload("uid://y1tn4hksvcmb")

func pick_a_fish() -> FishResource:
	var can_pick : Array[FishResource] = []
	var current_bait_type : FishResource.Bait = Globals.rod.bait_type
	for fish : FishResource in FISH_LIBRARY.fish:
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
