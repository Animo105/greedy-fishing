extends Container
class_name ProgressContainer

@export var progress_ratio : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child : Control in get_children():
		child.position.x = size.x * progress_ratio
