class_name State
extends Node

@warning_ignore("unused_signal")
signal transitioned(state: State, new_state_name: String)

func enter():
	pass
	
func exit():
	pass

func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
