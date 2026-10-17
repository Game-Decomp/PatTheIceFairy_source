extends Node2D

onready var area2d = $Area2D

func _process(delta):
	global_position = get_global_mouse_position()
	
	visible = area2d.get_overlapping_areas().size() == 0


func _enter_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
