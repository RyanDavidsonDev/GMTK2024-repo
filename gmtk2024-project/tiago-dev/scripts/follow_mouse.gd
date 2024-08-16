extends Node2D

func _process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var direction = (position - mouse_position).normalized()
	var speed = 200  # You can adjust the speed as needed
	position = get_global_mouse_position()
