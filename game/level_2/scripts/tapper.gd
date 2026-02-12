extends Node2D

signal level_completed

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var player = $tapperplayer

var cup_scene = preload("res://game/level_2/scenes/cup.tscn")

var player_near = false
var lives: int = 3
var can_spawn: bool = true
var game_active: bool = true
var win_target: int = 10000

# Lane system
var lane_bar_y = [20, 70, 120, 170]
var lane_npcs: Array = [null, null, null, null]

# NPC types: [scene, score_value]
var npc_types = [
	[preload("res://game/level_2/scenes/npc_junior.tscn"), 75],
	[preload("res://game/level_2/scenes/npc_detective.tscn"), 150],
	[preload("res://game/level_2/scenes/npc_artist.tscn"), 100],
]

func _ready():
	Global.score = 0
	score_label.text = "Score: 0"
	lives_label.text = "Lives: 3"

	# Create bar counters for each lane
	for bar_y in lane_bar_y:
		var bar_top = ColorRect.new()
		bar_top.z_index = -1
		bar_top.position = Vector2(120, bar_y)
		bar_top.size = Vector2(250, 18)
		bar_top.color = Color(0.545, 0.353, 0.169, 1)
		add_child(bar_top)

		var bar_front = ColorRect.new()
		bar_front.z_index = -1
		bar_front.position = Vector2(120, bar_y + 18)
		bar_front.size = Vector2(250, 12)
		bar_front.color = Color(0.396, 0.263, 0.129, 1)
		add_child(bar_front)

	# Set up player lane positions
	var player_positions = []
	for bar_y in lane_bar_y:
		player_positions.append(bar_y - 19)
	player.lane_positions = player_positions
	player.current_lane = 2
	player.position.y = player_positions[2]

	# Start NPC spawn timer
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 2.0
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer)
	add_child(spawn_timer)

func _on_spawn_timer():
	if not game_active:
		return
	# Find empty lanes
	var empty_lanes = []
	for i in lane_npcs.size():
		if lane_npcs[i] == null:
			empty_lanes.append(i)
	if empty_lanes.is_empty():
		return
	# Pick random empty lane
	var lane = empty_lanes[randi() % empty_lanes.size()]
	spawn_npc(lane)

func spawn_npc(lane: int):
	var type_data = pick_npc_type()
	var npc = type_data[0].instantiate()
	var bar_y = lane_bar_y[lane]
	npc.position = Vector2(338, bar_y - 7)
	npc.scale = Vector2(0.198, 0.198)
	npc.lane_index = lane
	npc.score_value = type_data[1]

	add_child(npc)
	lane_npcs[lane] = npc

	npc.reached_player.connect(_on_npc_reached_player.bind(npc))
	npc.cup_collected.connect(_on_cup_collected.bind(npc))

func pick_npc_type() -> Array:
	var eligible = [npc_types[0]]
	if Global.score >= 300:
		eligible.append(npc_types[1])
	if Global.score >= 6000:
		eligible.append(npc_types[2])
	return eligible[randi() % eligible.size()]

func _on_npc_reached_player(npc):
	lane_npcs[npc.lane_index] = null
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

func _on_cup_collected(progress: float, cup_y: float, npc):
	lane_npcs[npc.lane_index] = null
	spawn_empty_cup(progress, cup_y)

func spawn_empty_cup(start_progress: float, cup_y: float):
	var cup = cup_scene.instantiate()
	cup.position = Vector2(player.position.x + 30, cup_y)
	cup.scale = Vector2(0.3, 0.3)
	add_child(cup)

	var path_follow = cup.get_node("PathFollow2D")
	path_follow.progress_ratio = start_progress
	path_follow.direction = -1
	path_follow.speed = path_follow.speed * 0.5

	# Visual change to indicate empty cup
	var sprite = path_follow.get_node("Cup/Smoothie")
	sprite.modulate = Color(0.5, 0.5, 0.7, 0.8)

	# Different collision layer so NPC ignores it
	var cup_area = path_follow.get_node("Cup")
	cup_area.collision_layer = 256

	path_follow.cup_returned.connect(_on_empty_cup_returned.bind(cup_y))

func _on_empty_cup_returned(cup_y: float):
	if player_near and player.position.y == cup_y:
		pass # Player caught the empty cup on the correct lane
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
