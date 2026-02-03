extends Node2D

# Title screen script
# The actual "press space" handling is in game.gd

func _ready() -> void:
	# Clear overlay text on title screen
	if Overlay:
		Overlay.setTopLeft("")
