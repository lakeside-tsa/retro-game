extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
@export var speed = 300
func get_input():
	var inputdirection = Input.get_axis("left", "right")
	velocity.x = inputdirection * speed
func _physics_process(_delta):
	get_input()
	move_and_slide()
func _process(_delta):
	if Input.is_action_pressed("left"):
		animation.play("walk_left")
	elif Input.is_action_pressed("right"):
		animation.play("walk_right")	
	else:
		animation.play("idle")
