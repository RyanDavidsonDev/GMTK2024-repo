extends Node

@export_group("Spawn Settings", "spawn_")
@export var spawn_entities : Array[PackedScene]
@export_range(256, 1024, 0.1) var spawn_min_distance: int = 5 
@export_range(0.2, 10, 0.2) var spawn_delay: float = 5 

var player : Player

var timer = 0.0
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if timer <= 0.0:
		spawn()
		var variance = randi_range(0, int(spawn_delay)) * 0.45
		if randi_range(0, 1) == 0:
			variance *= -1
		timer = max(0, spawn_delay + variance)
	
	timer -= delta

func spawn():
	var random_direction = randi_range(0, 360)
	var min = spawn_min_distance
	var max = min + randi_range(0, int(min)) * 0.45
	var random_distance = randi_range(min, max)
	var spawn_position = player.global_position
	
	# Calculate the spawn position at random distance in the random direction
	spawn_position.x += random_distance * cos(deg_to_rad(random_direction))
	spawn_position.y += random_distance * sin(deg_to_rad(random_direction))
	
	var entity_index = randi_range(0, spawn_entities.size()-1)
	var entity = spawn_entities[entity_index].instantiate()
	entity.global_position = spawn_position
	add_child(entity)
