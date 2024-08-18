extends RadialSpawner

func _ready():
	super._ready()
	GameEvents.on_enemy_explode.connect(_enemy_to_pellet_cluster)

func _enemy_to_pellet_cluster(location: Vector2):
	# these values can be driven via class properties
	# or through some value from the enemy
	print("Enemy died at location " + str(location))
	var cluster_quantity := 3
	var distance := 5
	
	# call parent's spawn cluster function
	super.spawn_cluster(location, cluster_quantity, distance)
