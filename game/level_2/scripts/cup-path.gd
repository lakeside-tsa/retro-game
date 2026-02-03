extends PathFollow2D

signal cup_missed

var speed = 0.25
var direction = 1
var has_reached_end = false

func _physics_process(delta):
	if has_reached_end:
		return

	progress_ratio += speed * delta * direction

	if progress_ratio >= 1.0:
		has_reached_end = true
		cup_missed.emit()
		await get_tree().create_timer(1).timeout
		get_parent().queue_free()
