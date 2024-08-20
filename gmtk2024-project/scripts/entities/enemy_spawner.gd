extends RadialSpawner

@export_subgroup("timer range")
@export var timer_min: float = 1
@export var timer_max: float = 10
var timer_current = 5

@export_subgroup("spawn_num range")
@export var spawn_num_min: float = 1
@export var spawn_num_max_floor: float = 2
var spawn_num_max_curr: float = spawn_num_max_floor
@export var spawn_num_max_cap: float = 50

var spawn_num_current = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	GameEvents.on_player_size_changed.connect(update_spawn)

func update_spawn(curr :float, max: float):
	spawn_num_max_curr = lerp(spawn_num_max_floor, spawn_num_max_cap, 
		inverse_lerp(1, max, curr))
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#super._process(delta)



func spawn():
	spawn_num_current = randi_range(spawn_num_max_floor, spawn_num_max_curr)
	for i in spawn_num_current:
		var random_direction = randi_range(0, 360)
		var min_dist = spawn_min_distance
		var max_dist = min_dist + randi_range(0, int(min_dist)) * spawn_min_range_multiplier
		var random_distance = randi_range(min_dist, max_dist)
		var spawn_position = player.global_position
		
		# Calculate the spawn position at random distance in the random direction
		spawn_position.x += random_distance * cos(deg_to_rad(random_direction))
		spawn_position.y += random_distance * sin(deg_to_rad(random_direction))
		
		
		
		spawn_at_location(spawn_position)



func _timer_timeout():
	#if pool.get_non_active_node_by_type(pool_type):
		
	for i in spawn_num_current:
		spawn()
	
	timer_current = randf_range(timer_min, timer_max)
	timer.wait_time = timer_current
	
