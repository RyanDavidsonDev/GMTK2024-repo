class_name PlayerGun
extends AnimatedSprite2D

@export var firing_point : Node2D

signal shoot(position: Vector2, direction: Vector2)

var base_offset_x := 0.0
var recoil_speed = 80.0

func _ready():
	base_offset_x = offset.x
	
func _process(delta):
	_shooting()
	_recoiling(delta)
	
func _shooting():
	var mouse_position = get_global_mouse_position()
	var mouse_direction = global_position.direction_to(mouse_position)
	global_rotation = mouse_direction.angle()
	
	if Input.is_action_just_pressed("shoot"):
		SoundFx.play("shoot")
		shoot.emit(firing_point.global_position, mouse_direction)
		recoil()
		
func _recoiling(delta):
	if !is_equal_approx(base_offset_x, offset.x):
		offset.x = move_toward(offset.x, base_offset_x, delta*recoil_speed)
		if is_equal_approx(base_offset_x, offset.x):
			offset.x = base_offset_x

func recoil():
	offset.x = 0.0
	
