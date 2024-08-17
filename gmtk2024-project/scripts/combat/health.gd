extends Node
class_name Health

signal health_changed(previous_health :float, current_health: float)

@export var max_health := 10
var current_health := 0.0

func _ready():
	reset()

func damage(value : float) -> void:
	var previous_health = current_health + 0.0 
	current_health = current_health - value
	
	if current_health > max_health:
		current_health = max_health
	elif current_health < 0.0:
		current_health = 0.0
		
	health_changed.emit(previous_health, current_health)

func reset() -> void:
	current_health = max_health
