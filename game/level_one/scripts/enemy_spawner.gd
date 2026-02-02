extends Node2D
class_name EnemySpawner

const ROWS = 3
const COLUMNS = 11
const HORIZONTAL_SPACING = 80
const VERTICAL_SPACING = 80
const ENEMY_HEIGHT = 24
const START_Y_POSITION = -300

var enemy_scene = preload("res://exported/scenes/Enemy.tscn")

func _ready():
	var enemy_1_res = preload("res://exported/resourcfes/enemy_1.tres")
	var enemy_2_res = preload("res://exported/resourcfes/enemy_2.tres")
	var enemy_3_res = preload("res://exported/resourcfes/enemy_3.tres")

	for row in range(ROWS):
		var config_to_use

		match row:
			0:
				config_to_use = enemy_1_res
			1:
				config_to_use = enemy_2_res
			2:
				config_to_use = enemy_3_res

		var row_width = (COLUMNS * config_to_use.width * 3) \
			+ ((COLUMNS - 1) * HORIZONTAL_SPACING)

		var start_x = position.x - row_width / 2

		for col in range(COLUMNS):
			var x = start_x + (col * config_to_use.width * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POSITION + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)

			spawn_enemy(config_to_use, Vector2(x, y))

func spawn_enemy(config_to_use, spawn_position: Vector2):
	var enemy = enemy_scene.instantiate()
	add_child(enemy) # 👈 important
	enemy.global_position = spawn_position
	enemy.config = config_to_use
