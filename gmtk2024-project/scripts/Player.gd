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
@export var current_size: float  = 100
@export var max_size = 1000
@export var min_size = 10

var curr_scale: float = 1
@export var min_scale: float = .1
@export var max_scale: float = 10


@export var health :Health 

var move_dir:Vector2 = Vector2.ZERO
var mouse_dir:Vector2 #used for physics calculations
var look_dir:float #used for setting sprite direction
var dead : bool = false

func _ready():
	hitbox.damaged.connect(ReceiveDamage)

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
		
		
func  _physics_process(delta):
	if dead:
		return
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()
	
func kill():
	if dead:
		return
	print("you died")
		

func ReceiveDamage(attack: Attack):
	health.damage(attack.damage)
	print("current health: " + str(health.current_health))


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("get hit")
	pass # Replace with function body.

func collect_coin():
	change_size(size_inc)
	

func change_size(amount:float):
	current_size = clamp(current_size + amount, min_size, max_size)
	curr_scale = lerp(min_scale, max_scale, inverse_lerp(min_size, max_size, current_size))
	sprite_2d.scale = Vector2(curr_scale, curr_scale);
	hitbox.scale = Vector2(curr_scale, curr_scale);
	collider_box.scale = Vector2(curr_scale, curr_scale);
	print("your new size is " + str(current_size) + " your current scale is " + str(curr_scale))
	#todo:
	# health
	# decrement value
