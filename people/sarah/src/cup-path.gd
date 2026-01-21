extends PathFollow2D

var speed = 0.25
var direction = 1
var has_reached_end = false
@onready var body = $StaticBody2D

func _process(delta):
	if has_reached_end and progress_ratio <= 0.0:
		progress_ratio = 0.0
		set_process(false)

	progress_ratio += speed * delta * direction

	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		direction = -1
		has_reached_end = true

	elif progress_ratio <= 0.0:
		progress_ratio = 0.0
		direction = 1
