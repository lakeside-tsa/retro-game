extends Node2D

signal level_completed

@export var note_scene: PackedScene
var score := 0

func _ready():
	Global.score = 0
	$Score.text = "Score: 0"
	spawn_loop()

func spawn_loop():
	while true:
		spawn_note()
		await get_tree().create_timer(1.0).timeout

func spawn_note():
	var note = note_scene.instantiate()
	note.direction = ["left", "right", "up", "down"].pick_random()
	note.set_direction()

	match note.direction:
		"left": note.position = Vector2(-175, -350)
		"down": note.position = Vector2(-75, -350)
		"up": note.position = Vector2(25, -350)
		"right": note.position = Vector2(125, -350)

	$Notes.add_child(note)

func _process(_delta):
	check_input()

func check_input():
	for note in $Notes.get_children():
		if abs(note.position.y - $HitZone.position.y) < 50:
			if Input.is_action_just_pressed(note.direction):
				score += 1
				Global.score = score
				$Score.text = "Score: %d" % score
				note.queue_free()
