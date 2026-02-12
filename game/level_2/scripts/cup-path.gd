extends PathFollow2D

signal cup_missed
signal cup_returned

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
		get_parent().queue_free()
	elif progress_ratio <= 0.0:
		has_reached_end = true
		cup_returned.emit()
		get_parent().queue_free()

func collect():
	has_reached_end = true
	set_physics_process(false)
	get_parent().visible = false
	get_parent().queue_free()
