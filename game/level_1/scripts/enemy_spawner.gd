extends Node2D
class_name EnemySpawner

const ROWS = 3
const COLUMNS = 10
const HORIZONTAL_SPACING = 20
const ROW_HORIZONTAL_SPACING = { 0: 30, 1: 35 }
const VERTICAL_SPACING = 20
const ENEMY_HEIGHT = 24
const START_Y_POSITION = -280
const LEFT_BOUNDARY = -210.0
const RIGHT_BOUNDARY = 210.0
const STEP_DOWN_AMOUNT = 20.0

var enemy_scene = preload("res://game/level_1/scenes/Enemy.tscn")
var move_direction := 1.0  # 1.0 = right, -1.0 = left

func _ready():
	var enemy_1_res = load("res://game/level_1/resources/enemy_1.tres")
	var enemy_2_res = load("res://game/level_1/resources/enemy_2.tres")
	var enemy_3_res = load("res://game/level_1/resources/enemy_3.tres")

	for row in range(ROWS):
		var config_to_use

		match row:
			0:
				config_to_use = enemy_1_res
			1:
				config_to_use = enemy_2_res
			2:
				config_to_use = enemy_3_res

		var h_spacing = ROW_HORIZONTAL_SPACING.get(row, HORIZONTAL_SPACING)

		var row_width = (COLUMNS * config_to_use.width * 3) \
			+ ((COLUMNS - 1) * h_spacing)

		var start_x = position.x - row_width / 2

		for col in range(COLUMNS):
			var x = start_x + (col * config_to_use.width * 3) + (col * h_spacing)
			var y = START_Y_POSITION + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)

			spawn_enemy(config_to_use, Vector2(x, y))

func _physics_process(_delta):
	var hit_edge = false
	var enemies: Array[Node] = []

	for child in get_children():
		if child is Enemy:
			enemies.append(child)
			if child.global_position.x >= RIGHT_BOUNDARY or child.global_position.x <= LEFT_BOUNDARY:
				hit_edge = true

	if enemies.is_empty():
		return

	if hit_edge:
		move_direction *= -1.0
		for enemy in enemies:
			enemy.global_position.y += STEP_DOWN_AMOUNT

	var dir = Vector2(move_direction, 0)
	for enemy in enemies:
		enemy.movement_direction = dir

func spawn_enemy(config_to_use, spawn_position: Vector2):
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_position
	enemy.config = config_to_use
