extends CharacterBody2D

class_name Player

signal shoot

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var move_speed: float = 200

@onready var sprite_2d: Sprite2D = $Sprite2D
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

var move_dir:Vector2 = Vector2.ZERO
var mouse_dir:Vector2 #used for physics calculations
var look_dir:float #used for setting sprite direction
var dead : bool = false

func _ready():
	update_scales()
	hitbox.damaged.connect(ReceiveDamage)
	health.health_changed.connect(_on_health_changed)
	move_speed = default_speed
	GameEvents.on_player_health_changed.emit()

func _process(delta):
	#if Input.is_action_just_pressed("exit"):
	#	print("quit game") # basic infrastructure from the tutorial I was using, not worrying about it now
	
	look_dir = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
	mouse_dir = get_global_mouse_position() - position
	look_dir = mouse_dir.angle() + PI/2.0
	global_rotation = look_dir
	
	if Input.is_action_just_pressed("shoot"):
			
		#var Bullet = Bullet.new(look_dir, global_transform)
		#add_child(Bullet)
		#Bullet.global_position = global_position
		print("firing " + str(look_dir))
		
		print("ship direction" + str(look_dir))
		print("ship location" + str(transform))
		print("")
		shoot.emit(position, mouse_dir)
		change_size(size_dec)
		
func  _physics_process(delta):
	if dead:
		return
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()

func _on_health_changed():
	print("player health changed")
	GameEvents.on_player_health_changed.emit()

func kill():
	if dead:
		return
	print("you died")
	GameEvents.on_player_died.emit()

func ReceiveDamage(attack: Attack):
	health.damage(attack.damage)
	print("current health: " + str(health.current_health))
	GameEvents.on_player_health_changed.emit()
	if health.current_health <= 0.0:
		kill()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("get hit")

func collect_coin():
	change_size(size_inc)
	
func change_size(amount:float):
	current_size = clamp(current_size + amount, size_floor, size_cap)
	
	update_scales()
	GameEvents.on_player_health_changed.emit()
	print("your new size is " + str(current_size) + " your current scale is " + str(curr_scale))
	#todo:
	# health
	# decrement value

func update_scales():
	var t:float = inverse_lerp(size_floor, size_cap, current_size)
	curr_scale = lerp(scale_foor, scale_cap, t)
	sprite_2d.scale = Vector2(curr_scale, curr_scale);
	hitbox.scale = Vector2(curr_scale, curr_scale);
	collider_box.scale = Vector2(curr_scale, curr_scale);
	var healthPercentage:float = inverse_lerp(0, health.max_health, health.current_health)
	health.max_health = lerp(max_health_cap, max_health_floor, t)
	health.current_health = lerp(0, health.max_health, healthPercentage)
	move_speed = lerp(speed_cap, speed_floor, t)
	print("current health: " + str(health.current_health))
	print("speed " + str(move_speed))
