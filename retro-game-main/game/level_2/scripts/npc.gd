extends CharacterBody2D

signal reached_player
signal cup_collected(progress: float, cup_y: float)
signal drink_finished(progress: float, cup_y: float)

var speed: float = 30.0
var score_value: int = 1
var lane_index: int = 0
var spawn_x: float = 0.0
var drinking: bool = false
var returning: bool = false

@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	if drinking:
		return
	if returning:
		position.x -= speed * _delta
		if position.x <= spawn_x:
			queue_free()
		return
	position.x += speed * _delta
	if position.x >= 100:
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
	drinking = true
	anim.play("drink")
	await get_tree().create_timer(3.0).timeout
	anim.play("happy")
	await get_tree().create_timer(2.0).timeout
	drink_finished.emit(progress, cup_y)
	drinking = false
	returning = true
	anim.flip_h = true
	anim.play("walk")
