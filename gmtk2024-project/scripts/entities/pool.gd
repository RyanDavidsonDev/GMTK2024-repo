extends Node

class_name Pool

var types: Array[String] = ["bullets", "pellets", "enemies", "a_pellets"]

func _init() -> void:
	add_to_group("pool")

func add_to_non_active(node: Node2D, type: String):
	if type in types:
		node.add_to_group(type)

func remove_from_non_active(node: Node2D, type: String):
	if type in types:
		
		node.remove_from_group(type)

func get_non_active_node_by_type(type: String):
	if type in types:
		return get_tree().get_first_node_in_group(type)

func get_oldest_node

func get_num_active(type: String):
	return get_tree().get_node_count_in_group(type)



func get_random_active(type: String):
	if type in types:
		return 
