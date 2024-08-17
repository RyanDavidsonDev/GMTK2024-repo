extends Area2D

class_name Pellet

var spawner: radial_spawner

var active: bool
var certain_type: String

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_group("health")
@export var health_chance: float = 3
@export var heal_amount_min: float = 5
@export var heal_amount_max: float = 15

#"coin", "health"

var pool: Pool

func _ready() -> void:
	pool = get_tree().get_first_node_in_group("pool")
	var random_value = randi() % 100
	
	if random_value < health_chance:
		certain_type = "health"
		sprite_2d.modulate = Color.RED
	else:
		certain_type = "coin"
	
	active = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if certain_type == "coin":
			body.collect_coin()
		elif certain_type == "health":
			var heal_amount = randf_range(heal_amount_min, heal_amount_max)
			body.health.heal(heal_amount)
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
	
