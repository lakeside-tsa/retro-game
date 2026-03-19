extends Node2D

@export var laser_scene: PackedScene

func _input(_event):
	if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("tp_up"):
		var laser = laser_scene.instantiate() as Laser
		laser.global_position = get_parent().global_position - Vector2(0, 20)
		get_tree().current_scene.add_child(laser)
