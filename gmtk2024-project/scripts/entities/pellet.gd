extends Area2D

class_name Pellet

var spawner: RadialSpawner

var active: bool
var certain_type: String

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

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
		animated_sprite.animation = "health"
	else:
		animated_sprite.animation = "ammo"
		certain_type = "coin"
	
	animated_sprite.play(animated_sprite.animation)
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
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	active = true


func _on_hidden() -> void:
	pool.add_to_non_active(self, "pellets")
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	
	if spawner:
		spawner.remove_from_actives(self)
	else :
		print("error: pellet doesn't have a reference to spawner")
	active = false

func set_spawner(in_spawner: RadialSpawner):
	spawner = in_spawner
	
