extends Area2D

class_name EnemyProjectile
@export var speed = 200
var direction: Vector2 = Vector2.DOWN

const MAX_DISTANCE = 800.0
var _distance_traveled := 0.0

func _process(delta):
	var movement = direction * speed * delta
	position += movement
	_distance_traveled += movement.length()
	if _distance_traveled > MAX_DISTANCE:
		queue_free()
