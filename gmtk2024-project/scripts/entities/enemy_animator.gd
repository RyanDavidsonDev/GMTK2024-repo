extends Node

@export var sprite : Sprite2D
@export var state_machine : StateMachine
@export var chase_color : Color
@export var not_chase_color : Color
@onready var enemy : Enemy = get_owner()

var was_chasing = false
func _process(_delta: float) -> void:
	
	var is_chasing = state_machine.current_state.name == "Chase"
	
	if is_chasing != was_chasing:
		was_chasing = is_chasing
		var new_color = not_chase_color
		if is_chasing:
			new_color = chase_color
		#sprite.modulate = new_color
		
