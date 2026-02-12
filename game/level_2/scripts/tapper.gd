extends Node2D

signal level_completed

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var spawn_point = $SpawnPoint
@onready var player = $tapperplayer

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
	$NPC.cup_collected.connect(_on_cup_collected)

func _on_npc_reached_player():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	if lives <= 0:
		_on_game_over()

func _process(_delta):
	if player_near and Input.is_action_just_pressed("tp_action") and can_spawn:
		spawn_cup()

	if not game_active:
		return

	score_label.text = "Score: " + str(Global.score)

	if Global.score >= win_target:
		_on_win()
		return

func spawn_cup():
	var cup = cup_scene.instantiate()
	cup.position = Vector2(player.position.x + 30, player.position.y)
	cup.scale = Vector2(0.3, 0.3)
	add_child(cup)
	cup.get_node("PathFollow2D").cup_missed.connect(_on_cup_missed)

	can_spawn = false
	await get_tree().create_timer(0.5).timeout
	can_spawn = true

func _on_cup_collected(progress: float, cup_y: float):
	spawn_empty_cup(progress, cup_y)

func spawn_empty_cup(start_progress: float, cup_y: float):
	var cup = cup_scene.instantiate()
	cup.position = Vector2(player.position.x + 30, cup_y)
	cup.scale = Vector2(0.3, 0.3)
	add_child(cup)

	var path_follow = cup.get_node("PathFollow2D")
	path_follow.progress_ratio = start_progress
	path_follow.direction = -1

	# Visual change to indicate empty cup
	var sprite = path_follow.get_node("Cup/Smoothie")
	sprite.modulate = Color(0.5, 0.5, 0.7, 0.8)

	# Different collision layer so NPC ignores it
	var cup_area = path_follow.get_node("Cup")
	cup_area.collision_layer = 256

	path_follow.cup_returned.connect(_on_empty_cup_returned)

func _on_empty_cup_returned():
	if player_near:
		pass # Player caught the empty cup
	else:
		lives -= 1
		lives_label.text = "Lives: " + str(lives)
		if lives <= 0:
			_on_game_over()

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
 
