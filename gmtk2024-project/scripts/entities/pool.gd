extends Node

class_name Pool

var types_na: Array[String] = ["bullets", "pellets", "enemies"]

var types_a: Array[String] = ["bullets", "pellets", "enemies"]

var actives : Array[Node]

func _init() -> void:
	add_to_group("pool")

func add_to_non_active(node: Node2D, type: String):
	if type in types_na:
		node.remove_from_group(type + "_a")
		node.add_to_group(type)
		actives.push_back(node)

func remove_from_non_active(node: Node2D, type: String):
	if type in types_na:
		node.remove_from_group(type)
		node.add_to_group(type + "_a")

func get_non_active_node_by_type(type: String):
	if type in types_na:
		return get_tree().get_first_node_in_group(type)


func get_num_active(type: String):
	return get_tree().get_node_count_in_group(type + "_a")
	#return get_tree().get_node_count_in_group(type)



func get_oldest_active_node(type: String):
	if type in types_a:
		#var node:Node = actives.pop_front();
		#return node
		var activeNodes: Array[Node]
		activeNodes = get_tree().get_nodes_in_group(type+"_a")
		print("arr" + str(activeNodes))
		if activeNodes:
			return activeNodes[activeNodes.size() - 1]
		else :
			print("ERROR: active nodes is empty but we're trying to access it")
	else :
		print("not in types_a")
