extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
			
	if initial_state:
		var initial_state_name = initial_state.name.to_lower()
		current_state = states[initial_state_name]
	else: # fallback
		var first_state_name = states.keys()[0]
		current_state = states[first_state_name]
		print("state machine start fallback option. initial state set to: ", first_state_name)

	if current_state:
		current_state.enter()
	else:
		print("invalid state machine setup. no initial state found.")

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_state_transitioned(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("new state ", new_state_name, "not found in ", self.name)
		return
	
	# Clean up the previous state
	if current_state:
		current_state.exit()
	
	# Intialize the new state
	new_state.enter()
	current_state = new_state
