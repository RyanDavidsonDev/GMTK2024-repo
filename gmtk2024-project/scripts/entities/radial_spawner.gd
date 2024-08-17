extends Node

class_name radial_spawner

@export_group("Spawn Settings", "spawn_")
@export var spawn_entities : Array[PackedScene]
@export_range(256, 1024, 0.1) var spawn_min_distance: int = 5 
@export_range(0.2, 10, 0.2) var spawn_delay: float = 5 

@export var max_amount: int = 100
@export var pool_type: String 

var actives : Array[Node]

var player : Player
var pool: Pool

var type: String
var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.wait_time = spawn_delay
	
	timer.timeout.connect(_timer_timeout)
	
	timer.start()
	
	pool = get_tree().get_first_node_in_group("pool")
	
	for item in spawn_entities:
		for i in max_amount:
			var entity: Node2D = item.instantiate()
			pool.add_child(entity)
			if entity is Pellet:
				entity.set_spawner(self)
			entity.hide()
			#spawn()
	
	
	player = get_tree().get_first_node_in_group("player")


func spawn():
	var random_direction = randi_range(0, 360)
	var min = spawn_min_distance
	var max = min + randi_range(0, int(min)) * 0.45
	var random_distance = randi_range(min, max)
	var spawn_position = player.global_position
	
	# Calculate the spawn position at random distance in the random direction
	spawn_position.x += random_distance * cos(deg_to_rad(random_direction))
	spawn_position.y += random_distance * sin(deg_to_rad(random_direction))
	
	var entity: Node2D
	
	#if we're not full
	if actives.size()  < max_amount:
		entity = pool.get_non_active_node_by_type(pool_type)
	else:
		entity = actives.pop_front()
		#entity = pool.get_oldest_active_node(pool_type)
		if entity:
			entity.hide()
		

	
	#var entity_index = randi_range(0, spawn_entities.size()-1)
	if(entity):
		entity.global_position = spawn_position
		entity.show()
		actives.push_back(entity)
	else :
		print("error: entity not valid")

func _timer_timeout():
	#if pool.get_non_active_node_by_type(pool_type):
	spawn()
	
	var variance = randi_range(0, int(spawn_delay)) * 0.45
	if randi_range(0, 1) == 0:
		variance *= -1
	timer.wait_time = max(0, spawn_delay + variance)
	

func remove_from_actives(entity:Node):
	var index: int = actives.find(entity)
	if( index != -1): 
		actives.pop_at(index)
