extends Node

const DAY_DURATION : float = 150
const PULL_FORCE_PERCENT : float = 0.05

const MIN_CATCH_TIME : float = 0.1
const MAX_CATCH_TIME : float = 120

const MIN_SNAP_SPEED : float = 0.5
const MAX_SNAP_SPEED : float = 10

const MIN_FISH_SPEED : float = 0.01
const MAX_FISH_SPEED : float = 10

var money : float = 0
var day_count : int = 1
var unique_fish_caught : int = 0

func _ready() -> void:
	rod.snap_resistence = 1

var rod : Rod = Rod.new()
var current_habitat : int = 0
