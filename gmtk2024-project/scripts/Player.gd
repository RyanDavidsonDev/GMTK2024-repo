class_name Player
extends CharacterBody2D

@export var move_speed: float = 200
@export var player_gun: PlayerGun

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player_body_sprite: AnimatedSprite2D = $Body
@onready var collider_box: CollisionShape2D = $colliderBox
@onready var hitbox: Hitbox = $Hitbox

@export_group("resizing")
@export var size_inc: float = 10
@export var size_dec: float = -10

@export_subgroup("size range")
@export var current_size: float  = 100
@export var size_floor = 10
@export var size_cap = 1000

@export_subgroup("scale range")
var curr_scale: float = 1
@export var scale_foor: float = .1
@export var scale_cap: float = 10

@export_subgroup("health range")
@export var health :Health 
@export var max_health_floor :float
@export var max_health_cap :float

@export_subgroup("speed range")
var curr_speed: float = 300
@export var default_speed:float = 200

@export var speed_floor :float
@export var speed_cap :float

@export_group("barrel damage", "barrel_")
@export var barrel_hurtbox : Area2D
@export var barrel_damage_self : float = 15.0

var dead : bool = false
var barrel_self_attack := Attack.new()

func _ready():
	update_scales()
	hitbox.damaged.connect(_receive_damage)
	health.health_changed.connect(_on_health_changed)
	move_speed = default_speed
	GameEvents.on_player_health_changed.emit()
	player_gun.shoot.connect(_on_shoot)
	barrel_self_attack.damage = barrel_damage_self
	#barrel_hurtbox.area_entered.connect(_on_barrel_hurtbox_dealt_damage)

func _process(_delta):
	_update_move_animation()

func _update_move_animation():
	var is_moving = velocity.length_squared() > 0
	var animation = "idle"
	if is_moving:
		animation = "walk"
	
	if player_body_sprite.animation != animation:
		player_body_sprite.animation =animation
		player_body_sprite.play(animation)

func  _physics_process(_delta):
	if dead:
		return
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()

func _on_health_changed(_previous_health, _current_health):
	GameEvents.on_player_health_changed.emit()

func kill():
	if dead:
		return
	dead = true
	GameEvents.on_player_died.emit()

func _on_shoot(pos: Vector2, dir: Vector2):
	change_size(size_dec)
	GameEvents.on_player_shoot.emit(pos, dir)

func _receive_damage(attack: Attack):
	health.damage(attack.damage)
	print("player got hit")
	SoundFx.play("hit")
	GameEvents.on_player_health_changed.emit()
	if health.current_health <= 0.0:
		kill()

func _on_barrel_hurtbox_dealt_damage(_area: Area2D):
	_receive_damage(barrel_self_attack)
	player_gun.recoil()

func collect_coin():
	change_size(size_inc)
	SoundFx.play("ammo")

func heal(amount):
	health.heal(amount)
	SoundFx.play("heal")

func change_size(amount:float):
	current_size = clamp(current_size + amount, size_floor, size_cap)
	update_scales()
	GameEvents.on_player_health_changed.emit()

func update_scales():
	var t:float = inverse_lerp(size_floor, size_cap, current_size)
	curr_scale = lerp(scale_foor, scale_cap, t)
	player_gun.scale = Vector2(curr_scale, curr_scale) * 0.8;
	player_body_sprite.scale = Vector2(curr_scale, curr_scale);
	hitbox.scale = Vector2(curr_scale, curr_scale);
	collider_box.scale = Vector2(curr_scale, curr_scale);
	
	var healthPercentage:float = inverse_lerp(0, health.max_health, health.current_health)
	health.max_health = lerp(max_health_cap, max_health_floor, t)
	health.current_health = lerp(0, health.max_health, healthPercentage)
	move_speed = lerp(speed_cap, speed_floor, t)
