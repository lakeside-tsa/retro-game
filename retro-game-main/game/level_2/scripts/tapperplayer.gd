extends CharacterBody2D

var lane_positions_y: Array = []
var lane_positions_x: Array = []
var current_lane: int = 0

@onready var anim = $AnimatedSprite2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("tp_up") and current_lane > 0:
		current_lane -= 1
		position = Vector2(lane_positions_x[current_lane], lane_positions_y[current_lane])
		anim.play("change")
		await get_tree().create_timer(0.5).timeout
		anim.play("idle")
	elif event.is_action_pressed("tp_down") and current_lane < lane_positions_y.size() - 1:
		current_lane += 1
		position = Vector2(lane_positions_x[current_lane], lane_positions_y[current_lane])
		anim.play("change")
		await get_tree().create_timer(0.5).timeout
		anim.play("idle")
	elif event.is_action_pressed("tp_action"):
		anim.play("serve")

func play_lose():
	anim.play("lose")
