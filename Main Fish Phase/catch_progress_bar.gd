extends HBoxContainer
class_name CatchProgressBar

@onready var progress_bar_left: ProgressBar = $ProgressBarLeft
@onready var progress_bar_right: ProgressBar = $ProgressBarRight

func set_value(value : float):
	progress_bar_left.value = value
	progress_bar_right.value = value
	
