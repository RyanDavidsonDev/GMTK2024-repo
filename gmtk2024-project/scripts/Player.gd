class_name Player
extends CharacterBody2D

@export var move_speed: float = 200
@export var player_gun: PlayerGun

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player_body_sprite: AnimatedSprite2D = $Body
@onready var collider_box: CollisionShape2D = $colliderBox
@onready var hitbox: Hitbox = $Hitbox
@onready var ammo_activator_collider: CollisionShape2D = $AmmoActivator/AmmoActivatorCollider
@onready var camera: Camera2D = $Camera2D


@export_group("resizing")
@export var size_inc: float = 10
@export var evaluation_curve :Curve

@export_subgroup("size range")
@export var current_size: float  = 100
@export var size_floor = 10
@export var size_cap = 1000

@export_subgroup("scale range")
var curr_scale: float = 1
@export var scale_floor: float = .1
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

@export_subgroup("bullets")
@export var bullet_dmg_floor: float = 10
@export var bullet_dmg_cap: float =  30
@export var bullet_size_floor: float = .5
@export var bullet_size_cap: float = 2


@export_group("barrel damage", "barrel_")
@export var barrel_hurtbox : Area2D
@export var barrel_damage_self : float = 15.0
#@export var gun_coll_size_dec: float = -10

@export_group("camera")

@export_subgroup("zooming")
@export var zoom_change_value: float = .1
@export var zoom_max: float = 4
@export var zoom_min: float = 0.4

var dead : bool = false
var barrel_self_attack := Attack.new()

signal size_changed

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
	
	#if Input.is_action_just_released("scroll_up"):
		#change_zoom(zoom_change_value)
		#print(camera.get_zoom())
		##GameEvents.zoom_updated.emit()
	#if Input.is_action_just_released("scroll_down") and camera.get_zoom().x > zoom_min:
		#change_zoom(-zoom_change_value)
		##GameEvents.zoom_updated.emit()
		#print(camera.get_zoom())

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
	change_size(-size_inc)
	var damage: float = lerp(bullet_dmg_floor, bullet_dmg_cap, inverse_lerp(size_floor, size_cap, current_size))
	GameEvents.on_player_shoot.emit(pos, dir,curr_scale, damage)

func _receive_damage(attack: Attack, origin : Hurtbox):
	health.damage(attack.damage)
	print("player got hit")
	SoundFx.play("hit")
	GameEvents.on_player_health_changed.emit()
	if health.current_health <= 0.0:
		kill()

func _on_barrel_hurtbox_dealt_damage(_area: Area2D):
	_receive_damage(barrel_self_attack, _area as Hurtbox)
	player_gun.recoil()

func change_zoom(value: float):
	camera.set_zoom(camera.get_zoom() + Vector2(value, value))

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
	#curr_scale = evaluation_curve.sample_baked(t) * (scale_cap - scale_floor ) + scale_floor
	curr_scale = evaluate_curve(evaluation_curve, t, scale_floor, scale_cap)
	 #(scale_floor, scale_cap, t)
	#curr_scale = lerp(scale_floor, scale_cap, t)
	var new_scale: Vector2 = Vector2(curr_scale, curr_scale)
	player_gun.scale = new_scale * 0.8;
	player_body_sprite.scale = new_scale
	hitbox.scale = new_scale
	collider_box.scale = new_scale
	ammo_activator_collider.scale = Vector2(max(curr_scale, 1.0), max(curr_scale, 1.0))
	
	var healthPercentage:float = inverse_lerp(0, health.max_health, health.current_health)
	health.max_health = lerp(max_health_cap, max_health_floor, t)
	health.current_health = lerp(0, health.max_health, healthPercentage)
	#move_speed = lerp(speed_cap, speed_floor, t)
	move_speed = evaluate_curve(evaluation_curve, t, speed_cap, speed_floor)
	
	var num_of_health_units_max = (size_cap - size_floor )/size_inc
	var num_of_health_units_curr = (current_size - size_floor )/size_inc
	print("health units max " + str(num_of_health_units_max) + " curr " +str(num_of_health_units_curr))
	GameEvents.on_player_size_changed.emit(num_of_health_units_curr, num_of_health_units_max)


func _on_gun_hitbox_area_entered(area: Area2D) -> void:
	if(area != hitbox):
		print("gun hitbox area entered")
		change_size(-size_inc)
		SoundFx.play("hit_barrel")

func evaluate_curve(curve: Curve, t:float, floor :float, cap: float) -> float:
	var sample :float  = curve.sample_baked(t)
	var range : float = cap - floor
	var result: float = sample * range + floor
	print("curve eval: " +str(sample))
	return result
