extends Node

const GEAR_FOLDER_PATH = "res://Gears/Resources/"

var bait_list : Array[GearResource]
var spoon_list : Array[GearResource]
var hook_list : Array[GearResource]
var line_list : Array[GearResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_gear_from_folder(GEAR_FOLDER_PATH)

func load_gear_from_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null: return

	for file in dir.get_files():
		var file_path := path.path_join(file)
		if ResourceLoader.exists(file_path):
			var res = ResourceLoader.load(file_path)
			if res is GearResource:
				if res.type == GearResource.Type.BAIT:
					bait_list.append(res)
				elif res.type == GearResource.Type.SPOON:
					spoon_list.append(res)
				elif res.type == GearResource.Type.HOOK:
					hook_list.append(res)
				elif res.type == GearResource.Type.LINE:
					line_list.append(res)

	for folder in dir.get_directories():
		load_gear_from_folder(path.path_join(folder))
