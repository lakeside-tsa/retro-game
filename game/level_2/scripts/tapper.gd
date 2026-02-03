extends Node2D

signal level_completed

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var spawn_point = $SpawnPoint

var cup_scene = preload("res://game/level_2/scenes/cup.tscn")
var player_near = false
var lives: int = 3
var can_spawn: bool = true
var game_active: bool = true
var win_target: int = 10

func _ready():
	Global.score = 0
	score_label.text = "Score: 0"
	lives_label.text = "Lives: 3"
	$NPC.reached_player.connect(_on_npc_reached_player)

func _on_npc_reached_player():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	if lives <= 0:
		_on_game_over()

func _process(_delta):
	if Input.is_action_just_pressed("tp_action"):
		print("Space pressed")
	if player_near:
		print("Player near")

	if player_near and Input.is_action_just_pressed("tp_action") and can_spawn:
		print("Trying to spawn cup")
		spawn_cup()

	if not game_active:
		return

	score_label.text = "Score: " + str(Global.score)

	if Global.score >= win_target:
		_on_win()
		return

	if player_near and Input.is_action_just_pressed("tp_action") and can_spawn:
		spawn_cup()

func spawn_cup():
	var cup = cup_scene.instantiate()
	add_child(cup)
	cup.position = spawn_point.position
	cup.scale = Vector2(0.1, 0.1)
	cup.get_node("PathFollow2D").cup_missed.connect(_on_cup_missed)

	can_spawn = false
	await get_tree().create_timer(0.5).timeout
	can_spawn = true

func _on_cup_missed():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	if lives <= 0:
		_on_game_over()

func _on_win():
	game_active = false
	score_label.text = "YOU WIN!"
	level_completed.emit()

func _on_game_over():
	game_active = false
	score_label.text = "GAME OVER"
	lives_label.text = "Lives: 0"

func _on_player_area_body_entered(body):
	if body.name == "tapperplayer":
		player_near = true

func _on_player_area_body_exited(body):
	if body.name == "tapperplayer":
		player_near = false
