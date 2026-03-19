extends PathFollow2D

signal cup_missed
signal cup_returned

var speed = 0.12
var direction = 1
var has_reached_end = false
var miss_x: float = -9999.0

func _physics_process(delta):
	if has_reached_end:
		return

	progress_ratio += speed * delta * direction

	if direction == 1 and get_node("Cup").global_position.x <= miss_x:
		has_reached_end = true
		cup_missed.emit()
		var sprite = get_node("Cup/Smoothie")
		sprite.play("broken")
		await get_tree().create_timer(1.0).timeout
		get_parent().queue_free()
	elif progress_ratio >= 1.0:
		has_reached_end = true
		cup_missed.emit()
		get_parent().queue_free()
	elif progress_ratio <= 0.0:
		has_reached_end = true
		cup_returned.emit()
		var sprite = get_node("Cup/Smoothie")
		sprite.play("broken")
		await get_tree().create_timer(1.0).timeout
		get_parent().queue_free()

func collect():
	has_reached_end = true
	set_physics_process(false)
	get_parent().visible = false
	get_parent().queue_free()
