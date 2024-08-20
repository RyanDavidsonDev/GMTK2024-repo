class_name Enemy
extends CharacterBody2D

signal DropPellets(location:Vector2)
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

@export_group("Movement")
@export var detection_radius : float = 500.0
@export var chase_radius := 800.0
@export var follow_radius := 16.0
@export var last_direction := Vector2(0.0, 0.0)

@export_group("Combat")
@export var hitbox : Hitbox
@export var health_min : int = 5
@export var health_max : int = 15
@export var health : Health


var dying : bool

var active: bool

var pool: Pool

func _ready():
	pool = get_tree().get_first_node_in_group("pool")
	DropPellets.emit()
	active = true
	hitbox.damaged.connect(_receive_damage)
	health.health_changed.connect(_on_health_changed)

func _receive_damage(attack : Attack, origin: Hurtbox):
	print("emitting" + str(min(health.current_health, attack.damage)))
	origin.damage_dealt.emit(min(health.current_health, attack.damage))
	health.damage(attack.damage)
	SoundFx.play("hit")

func _on_health_changed(previous_health: float, current_health: float) -> void:
	#print("prev: ", previous_health, "cur: ", current_health)
	# in case we take multiple hits that take our life to 0
	# we just delete the object once
	if current_health <= 0.0 and previous_health != current_health:
		health.reset()
		GameEvents.on_enemy_explode.emit(global_position)
		kill()
	#else:
		#print("warning, pellet spawner broke")
		#self.process_mode = PROCESS_MODE_DISABLED

func _on_draw() -> void:
	
	health.current_health = randi_range(health_min, health_max)
	
	animated_sprite.play("Chomper_walk")

	$HitBox/CollisionShape2D.set_deferred("disabled", false)
	$HurtBox/CollisionShape2D.set_deferred("disabled", false)
	$MovementCollision.set_deferred("disabled", false)
	dying = false
	
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


func _on_attacked_player(area: Area2D) -> void:
	if area is Hitbox:
		print("attacking player, dying but not dropping pellets")
		kill();



func kill():
	dying = true
	animated_sprite.play("Explode")
	animated_sprite.animation_finished.connect(hide)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$MovementCollision.set_deferred("disabled", true)
