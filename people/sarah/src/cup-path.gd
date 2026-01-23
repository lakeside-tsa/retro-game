extends PathFollow2D

var speed = 0.25
var direction = 1
var has_reached_end = false
@onready var body = $StaticBody2D

func _process(delta):
	if has_reached_end:
		progress_ratio = 1.0

	progress_ratio += speed * delta * direction

	if progress_ratio >= 1.0:
		progress_ratio = 1.0
		has_reached_end = true
		await get_tree().create_timer(1).timeout
		queue_free()
		set_process(false)
