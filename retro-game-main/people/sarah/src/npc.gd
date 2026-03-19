extends CharacterBody2D

signal reached_player

var speed: float = 30.0
var start_position: Vector2

func _ready():
	start_position = position

func _physics_process(_delta):
	position.x -= speed * _delta
	if position.x <= 120:
		reached_player.emit()
		reset_position()

func reset_position():
	position = start_position

func _on_body_entered(body):
	Global.score += 1
	print("Cup caught! Score: ", Global.score)
	body.get_parent().get_parent().queue_free()
	reset_position()
