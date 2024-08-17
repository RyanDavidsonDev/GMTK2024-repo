extends Area2D

class_name Pellet

var spawner: radial_spawner

var active: bool
var certain_type: String

@export_group("health")
@export var health_chance: float = 3

#"coin", "health"

var pool: Pool

func _ready() -> void:
	pool = get_tree().get_first_node_in_group("pool")
	var random_value = randi() % 100
	
	if random_value < health_chance:
		certain_type = "health"
	else:
		certain_type = "coin"
	
	active = true

func _on_body_entered(body: Node2D) -> void:
	print("player collected coin")
	if body is Player:
		print("player")
		if certain_type == "coin":
			body.collect_coin()
		elif certain_type == "health":
			body.health.reset()
		
		hide()


func _on_draw() -> void:
	pool.remove_from_non_active(self, "pellets")
	monitorable = true
	monitoring = true
	active = true


func _on_hidden() -> void:
	pool.add_to_non_active(self, "pellets")
	monitorable = false
	monitoring = false
	if spawner:
		spawner.remove_from_actives(self)
	else :
		print("error: pellet doesn't have a reference to spawner")
	active = false

func set_spawner(spawner: radial_spawner):
	self.spawner = spawner
	
