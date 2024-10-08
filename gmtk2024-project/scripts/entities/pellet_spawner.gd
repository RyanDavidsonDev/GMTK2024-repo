extends RadialSpawner

@export_group("pellet drops")
@export var min_num_of_pellets: int = 2
@export var max_num_of_pellets: int = 5
@export var distance : float = 10
func _ready():
	super._ready()
	print("pellet spawner")
	GameEvents.on_enemy_explode.connect(spawn_cluster)

func spawn_cluster(location: Vector2):
	# these values can be driven via class properties
	# or through some value from the enemy
	
	print("")
	
	var cluster_quantity: int = randi_range(min_num_of_pellets, max_num_of_pellets)
	
	for i in cluster_quantity:
		var random_direction = randi_range(0, 360)
		var random_distance = randf_range(0,distance)
		
		var spawn_position: Vector2
		spawn_position.x = location.x + random_distance * cos(deg_to_rad(random_direction))
		spawn_position.y = location.y + random_distance * sin(deg_to_rad(random_direction))
		
		print("pellet")
		super.spawn_at_location(spawn_position)
	
	print((""))
	
	
