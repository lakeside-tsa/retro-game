extends Area2D

@export var speed := 300
@export var direction := "left"

func _ready():
	set_direction()

func _process(delta):
	position.y += speed * delta

	if position.y > 800:
		queue_free()

func set_direction() -> void:
	match direction:
		"up":
			$Sprite2D.rotation_degrees = -90
		"down":
			$Sprite2D.rotation_degrees = 90
		"left":
			$Sprite2D.rotation_degrees = 180
		"right":
			$Sprite2D.rotation_degrees = 0
