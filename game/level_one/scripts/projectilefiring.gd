extends Node2D

@export var laser_scene: PackedScene

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		var laser = laser_scene.instantiate() as Laser
		laser.global_position = get_parent().global_position - Vector2(0,20)
		get_tree().root.get_node("level_1").add_child(laser)
