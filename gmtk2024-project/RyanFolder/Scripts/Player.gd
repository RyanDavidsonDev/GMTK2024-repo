extends CharacterBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var move_speed: float = 200
@export var size: float  = 200

var dead : bool = false

func _process(dealta):
	if Input.is_action_just_pressed("exit"):
		print("quit game") # basic infrastructure from the tutorial I was using, not worrying about it now
	
	
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0 + deg_to_rad(45)
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func  _physics_process(delta):
	if dead:
		return
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()
	
func kill():
	if dead:
		return
	print("you died")
		
func shoot():
	print("firing")
