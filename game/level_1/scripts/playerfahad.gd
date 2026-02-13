extends CharacterBody2D

signal player_hit

@export var speed = 400

func _physics_process(_delta):
	var input = Input.get_axis("p1_left", "p1_right")
	if input == 0:
		input = Input.get_axis("left", "right")

	velocity.x = input * speed
	move_and_slide()

func _on_player_hit(area):
	if area is EnemyProjectile:
		area.queue_free()
		player_hit.emit()
