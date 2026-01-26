extends CharacterBody2D

class_name Enemy
@export var speed = 10
var health=100
@onready var sprite_2d = $Sprite2D
const damage=40
var config: Resource
var movement_direction=1

func _physics_process(delta):
	movement_direction = Vector2.DOWN
	velocity = speed * movement_direction
	move_and_slide()


func _on_hitbox_area_entered(area):
	if area is Laser:
		health-= damage
		area.queue_free()
	if health<=0:
		queue_free()
		
		
