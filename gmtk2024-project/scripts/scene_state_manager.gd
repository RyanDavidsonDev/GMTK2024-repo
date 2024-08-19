extends Node

func set_scene_state(scene: Node, state: String):
	match state:
		"paused":
			print("Scene: " + str(scene) + "was paused")
			scene.process_mode = PROCESS_MODE_DISABLED
		"resumed":
			print("Scene: " + str(scene) + "was resumed")
			scene.process_mode = PROCESS_MODE_PAUSABLE

func get_scene_state_raw(scene: Node):
	return scene.process_mode

func get_scene_state(scene: Node):
	var state: String
	
	if scene.process_mode == 0:
		state == "resumed"
	else:
		state == "paused"
	
	return state
