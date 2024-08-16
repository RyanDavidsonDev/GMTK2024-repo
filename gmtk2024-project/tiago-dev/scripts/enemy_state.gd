class_name EnemyState
extends State

@onready var enemy : Enemy = get_owner()

var target : Node2D

func _ready():
	if enemy == null:
		print("invalid state - no owner of type enemy")
	
func enter():
	pass
	
func exit():
	pass

func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass

## shared state functionality
func get_distance_to_target() -> float:
	return target.global_position.distance_to(enemy.global_position)

func try_chase() -> bool:
	if get_distance_to_target() <= enemy.detection_radius:
		transitioned.emit(self, "chase")
		return true
	
	return false
