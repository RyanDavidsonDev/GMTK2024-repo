class_name Enemy
extends CharacterBody2D

@export_group("Movement")
@export var detection_radius : float = 500.0
@export var chase_radius := 800.0
@export var follow_radius := 16.0
@export var last_direction := Vector2(0.0, 0.0)

@export_group("Combat")
@export var hitbox : Hitbox
@export var health : Health



var active: bool

var pool: Pool

func _ready():
	pool = get_tree().get_first_node_in_group("pool")
	
	active = true
	hitbox.damaged.connect(_receive_damage)
	health.health_changed.connect(_on_health_changed)
	
func _receive_damage(attack : Attack):
	health.damage(attack.damage)

func _on_health_changed(previous_health: float, current_health: float) -> void:
	#print("prev: ", previous_health, "cur: ", current_health)
	
	# in case we take multiple hits that take our life to 0
	# we just delete the object once
	if current_health <= 0.0 and previous_health != current_health:
		# instead of deleting, we can disable and reuse
		# (i.e. pooling on an enemy manager)
		queue_free()


func _on_draw() -> void:
	pool.remove_from_non_active(self, "pellets")
	hitbox.monitorable = true
	hitbox.monitoring = true
	active = true


func _on_hidden() -> void:
	pool.add_to_non_active(self, "pellets")
	hitbox.monitorable = false
	hitbox.monitoring = false
	active = false
