class_name PlayerGun
extends AnimatedSprite2D

@export var firing_point : Node2D
@onready var player: Player = $".."

signal shoot(position: Vector2, direction: Vector2)

var base_offset_x := 0.0
var recoil_speed = 80.0
var _suppress_count := 0
var _can_shoot := true

func _ready():
	base_offset_x = offset.x
	GameEvents.on_supress_player_shoot.connect(_on_supress_player_shoot)
	
func _process(delta):
	_shooting()
	_recoiling(delta)

func _on_supress_player_shoot(change:int):
	_suppress_count += change
	_can_shoot = _suppress_count <= 0

func _shooting():
	
	var mouse_position = get_global_mouse_position()
	var mouse_direction = global_position.direction_to(mouse_position)
	global_rotation = mouse_direction.angle()
	
	if _can_shoot && Input.is_action_just_pressed("shoot"):
		if(!is_equal_approx(player.current_size, player.size_floor)):
			print("size" + str(player.current_size) + "other size" + str(player.size_floor))
			SoundFx.play("shoot")
			var curr_scale :float = max(player.curr_scale,.7)
			shoot.emit(firing_point.global_position, mouse_direction)
			recoil()
		else :
			if (player.current_size + player.size_inc < player.size_floor):
				return
			else :
				player.current_size = player.size_floor
				return
		
func _recoiling(delta):
	if !is_equal_approx(base_offset_x, offset.x):
		offset.x = move_toward(offset.x, base_offset_x, delta*recoil_speed)
		if is_equal_approx(base_offset_x, offset.x):
			offset.x = base_offset_x

func recoil():
	offset.x = 0.0
	
