extends CharacterBody2D

class_name Player

signal shoot

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var move_speed: float = 200
@export var size: float  = 200
@export var hitbox : Hitbox

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
			
		#var pellet = Pellet.new(look_dir, global_transform)
		#add_child(pellet)
		#pellet.global_position = global_position
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
