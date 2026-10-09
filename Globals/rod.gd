extends RefCounted
class_name Rod

enum CatchZoneBehavior {
	HEAVY,
	LIGHT,
	SPEEDY,
}

## DEPRICATED
var pull_strenght : float = 0.0

var catch_zone_speed : float = 0.05
var snap_resistence : float = 0
var catch_zone_size : float = 0.1
var catch_speed : float = 0
var rarity : float = 0

var bait_gear : GearResource = null
var spoon_gear : GearResource = null
var line_gear : GearResource = null
var hook_gear : GearResource = null

var bait_type : FishResource.Bait = FishResource.Bait.ANY

func calculate_stats():
	catch_zone_speed = 0.1
	snap_resistence = 0
	catch_zone_size = 0.1
	catch_speed = 0
	rarity = 0
	bait_type = FishResource.Bait.ANY
	if bait_gear:
		_append_gear(bait_gear)
		if bait_gear.level == 0:
			bait_type = FishResource.Bait.WORM
		if bait_gear.level == 1:
			bait_type = FishResource.Bait.SHRIMP
		elif bait_gear.level == 2:
			bait_type = FishResource.Bait.OCTOPUS
	if spoon_gear:
		_append_gear(spoon_gear)
	if line_gear:
		_append_gear(line_gear)
	if hook_gear:
		_append_gear(hook_gear)

func swap_gear(gear : GearResource):
	match gear.type :
		GearResource.Type.BAIT :
			bait_gear = gear
		GearResource.Type.SPOON :
			spoon_gear = gear
		GearResource.Type.LINE :
			line_gear = gear
		GearResource.Type.HOOK :
			hook_gear = gear

func _append_gear(gear : GearResource):
	catch_zone_speed += gear.strenght
	snap_resistence += gear.snap
	catch_speed += gear.speed
	rarity += gear.rarity

func duplicate() -> Rod:
	var rod = Rod.new()
	rod.bait_gear = bait_gear
	rod.bait_type = bait_type
	rod.hook_gear = hook_gear
	rod.spoon_gear = spoon_gear
	rod.rarity = rarity
	rod.line_gear = line_gear
	return rod
