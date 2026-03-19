extends CharacterBody2D

const MOVE_DISTANCE = 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tp_up"):
		position.y -= MOVE_DISTANCE
	elif event.is_action_pressed("tp_down"):
		position.y += MOVE_DISTANCE
