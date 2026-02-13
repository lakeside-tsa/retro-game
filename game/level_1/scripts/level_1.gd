extends Node2D

signal level_completed

@onready var lives_label = $LivesLabel
@onready var game_over_label = $GameOverLabel
@onready var player = $Playerfahad

var lives: int = 3
var game_active: bool = true
var enemy_projectile_scene = preload("res://game/level_1/scenes/enemy_projectile.tscn")

func _ready():
	lives_label.text = "Lives: 3"
	player.player_hit.connect(_on_player_hit)

	var shoot_timer = Timer.new()
	shoot_timer.wait_time = 0.5
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(_on_enemy_shoot_timer)
	add_child(shoot_timer)

func _on_enemy_shoot_timer():
	if not game_active:
		return
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return
	var shoot_chance = clampf(enemies.size() / 30.0, 0.05, 1.0)
	if randf() > shoot_chance:
		return
	var shooter = enemies[randi() % enemies.size()]
	var projectile = enemy_projectile_scene.instantiate()
	var spawn_pos = shooter.global_position + Vector2(0, 20)
	projectile.global_position = spawn_pos
	projectile.direction = (player.global_position - spawn_pos).normalized()
	add_child(projectile)

func _on_enemy_reached_bottom(body):
	if not game_active:
		return
	if body is Enemy:
		body.queue_free()
		lives -= 1
		lives_label.text = "Lives: " + str(lives)
		if lives <= 0:
			_on_game_over()

func _on_player_hit():
	if not game_active:
		return
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	if lives <= 0:
		_on_game_over()

func _on_game_over():
	game_active = false
	lives_label.text = "Lives: 0"
	game_over_label.visible = true
