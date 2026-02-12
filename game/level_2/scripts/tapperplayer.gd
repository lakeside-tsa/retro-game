extends CharacterBody2D

var lane_positions: Array = []
var current_lane: int = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tp_up") and current_lane > 0:
		current_lane -= 1
		position.y = lane_positions[current_lane]
	elif event.is_action_pressed("tp_down") and current_lane < lane_positions.size() - 1:
		current_lane += 1
		position.y = lane_positions[current_lane]
