extends Node

signal level_completed

# Level paths - customize these as you add levels
var level_scenes = {
	-1: "res://game/scenes/title_screen.tscn",  # Title screen
	0: "res://game/hub/hub.tscn",               # Hub
	1: "res://game/level_1/scenes/level_1.tscn",  # Space invaders
	2: "res://game/level_2/scenes/tapper_scene.tscn",  # Tapper
	3: "res://game/level_3/scenes/ddr_scene.tscn",  # DDR
}

@onready var current_level_number = -1
@onready var current_level_node: Node = null
@onready var camera: Camera2D = $Camera2D

func _ready():
	load_level(-1)  # Start at title screen


func load_level(level_number: int):
	# Check if level exists
	if not level_scenes.has(level_number) or level_scenes[level_number] == null:
		push_warning("Level %d not found or not implemented" % level_number)
		return

	current_level_number = level_number

	# Clean up previous level
	if current_level_node:
		current_level_node.queue_free()
		await current_level_node.tree_exited

	# Load new level
	var level_scene = load(level_scenes[level_number])
	current_level_node = level_scene.instantiate()
	add_child(current_level_node)

	# Try to connect level_completed signal if the level has it
	if current_level_node.has_signal("level_completed"):
		current_level_node.connect("level_completed", Callable(self, "_on_level_completed"))

	# Reset score for new level (optional - remove if you want persistent score)
	if level_number > 0:
		Global.score = 0


func _on_level_completed():
	await get_tree().create_timer(2.0).timeout
	# Return to hub after completing a level
	load_level(0)


func _unhandled_input(event: InputEvent) -> void:
	# Debug: number keys to load levels directly
	if event.is_action_pressed("num01"):
		load_level(1)
	elif event.is_action_pressed("num02"):
		load_level(2)
	elif event.is_action_pressed("num03"):
		load_level(3)
	elif event.is_action_pressed("num04"):
		load_level(0)  # Back to hub

	# Title screen: space to start
	elif current_level_number == -1 and event.is_action_pressed("ui_accept"):
		load_level(0)  # Go to hub
