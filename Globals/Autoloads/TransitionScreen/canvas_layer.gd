extends CanvasLayer

signal faded

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func call_between_fade(callable : Callable):
	fade_in()
	await faded
	await callable.call()
	fade_out()

func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	faded.emit()

func fade_out():
	animation_player.play("fade_out")
