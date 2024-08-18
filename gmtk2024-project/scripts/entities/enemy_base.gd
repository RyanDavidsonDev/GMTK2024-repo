class_name Enemy
extends CharacterBody2D

signal DropPellets(location:Vector2)

@export_group("Movement")
@export var detection_radius : float = 500.0
@export var chase_radius := 800.0
@export var follow_radius := 16.0
@export var last_direction := Vector2(0.0, 0.0)

@export_group("Combat")
@export var hitbox : Hitbox
@export var health : Health

@export_group("pellet drops")
@export var num_of_pellets: int = 3
@export var distance : float = 5

var active: bool

var pool: Pool

func _ready():
	pool = get_tree().get_first_node_in_group("pool")
	DropPellets.emit()
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
		health.reset()
		hide()
		GameEvents.on_enemy_explode.emit(position)
	#else:
		#print("warning, pellet spawner broke")
		#self.process_mode = PROCESS_MODE_DISABLED

func _on_draw() -> void:
	pool.remove_from_non_active(self, "enemies")
	hitbox.monitorable = true
	hitbox.monitoring = true
	active = true
	self.process_mode = PROCESS_MODE_PAUSABLE

func _on_hidden() -> void:	
	position = Vector2(10000, 10000)
	pool.add_to_non_active(self, "enemies")
	#hitbox.monitorable = false
	#hitbox.monitoring = false
	#active = false
	#self.process_mode = PROCESS_MODE_DISABLED
