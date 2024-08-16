extends Node2D

@export var pellet_scene : PackedScene


func _on_player_shoot(pos: Vector2, dir:Vector2):
	print("spanwed")
	var pellet = pellet_scene.instantiate(dir)
	add_child(pellet)
	pellet.position = pos
	pellet.direction = dir.normalized()
	add_to_group("bullets")
	
	
