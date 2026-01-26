extends Node2D

class_name EnemySpawner

const ROWS = 3
const COLUMNS = 11
const HORIZONTAL_SPACING = 80
const VERTICAL_SPACING = 80
const ENEMY_HEIGHT = 24
const START_Y_POSITION = -50
const ENEMY_POSITION_X_INCREMENT = 10
const INVADERS_POSITION_Y_INCREMENT = 20

var movement_direction = 1
var enemy_scene = preload("res://exported/scenes/lvl_1_critter_111.tscn")

func _ready():
	var enemy_1_res = preload("res://exported/resourcfes/enemy_1.tres")
	
	
	var enemy_config
	
	for row in ROWS:
		if row == 0:
			enemy_config = enemy_1_res
		
		var row_width = (COLUMNS * enemy_config.width * 3) + ((COLUMNS - 1) * HORIZONTAL_SPACING)
		var start_x = (position.x - row_width) / 2
		
		for col in COLUMNS:
			var x = start_x + (col * enemy_config.width * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POSITION + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_position = Vector2(x, y)
			
			spawn_enemy(enemy_config, spawn_position)

func spawn_enemy(enemy_config, spawn_position: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy_config = enemy.config
	enemy.global_position = spawn_position
	add_child(enemy)

	
