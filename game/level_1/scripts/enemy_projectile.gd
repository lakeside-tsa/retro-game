extends Area2D

class_name EnemyProjectile
@export var speed = 200
var direction: Vector2 = Vector2.DOWN

func _process(delta):
	position += direction * speed * delta
