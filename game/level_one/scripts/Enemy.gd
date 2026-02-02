extends CharacterBody2D
class_name Enemy

@export var speed := 10.0
var health := 100

@onready var sprite_2d: Sprite2D = $Sprite2D

const DAMAGE = 40
var movement_direction = Vector2.DOWN

# 🔑 backing variable
var _config: EnemyConfig

@export var config: EnemyConfig:
	set(value):
		_config = value
		apply_config()
	get:
		return _config

func _ready():
	apply_config()

func apply_config():
	if _config == null or !is_inside_tree():
		return

	sprite_2d.texture = _config.texture
	speed = _config.speed
	health = _config.health

func _physics_process(delta):
	velocity = speed * movement_direction
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area is Laser:
		health -= DAMAGE
		area.queue_free()
		if health <= 0:
			queue_free()
