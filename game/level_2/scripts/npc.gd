extends CharacterBody2D

signal reached_player
signal cup_collected(progress: float, cup_y: float)

var speed: float = 30.0
var score_value: int = 1
var lane_index: int = 0

func _physics_process(_delta):
	position.x -= speed * _delta
	if position.x <= 120:
		reached_player.emit()
		queue_free()

func _on_area_entered(area):
	var path_follow = area.get_parent()
	if path_follow.direction == -1:
		return
	var progress = path_follow.progress_ratio
	var cup_y = path_follow.get_parent().position.y
	Global.score += score_value
	path_follow.collect()
	cup_collected.emit(progress, cup_y)
	queue_free()
