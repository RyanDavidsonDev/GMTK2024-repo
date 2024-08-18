extends CharacterBody2D

class_name Player

signal shoot

@onready var firing_point : Node2D = $FiringPoint
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var move_speed: float = 200

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider_box: CollisionShape2D = $colliderBox
@onready var camera: Camera2D = $Camera2D
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

@export_subgroup("camera zoom range")
@export var zoom_floor: float = 1
@export var zoom_cap: float = 2


@export_group("level settings")
@export var next_level_res_modifier: float = 1.4
@export var overall_stat_modifier: float = 1.2
@export var max_level: int = 24
var resources_to_level_up: int = 80
var resources_per_shoot: float = 5
var current_level: int = 2
var current_resources: float = 0


var move_dir:Vector2 = Vector2.ZERO
var mouse_dir:Vector2 #used for physics calculations
var look_dir:float #used for setting sprite direction
var dead : bool = false

func _ready():
	update_scales(size_inc)
	hitbox.damaged.connect(ReceiveDamage)
	health.health_changed.connect(_on_health_changed)
	move_speed = default_speed
	
	GameEvents.on_player_level_changed.connect(_on_player_level_changed)
	
	GameEvents.on_player_health_changed.emit()

func _process(_delta):
	look_dir = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
	mouse_dir = get_global_mouse_position() - position
	look_dir = mouse_dir.angle() + PI/2.0
	global_rotation = look_dir
	
	if Input.is_action_just_pressed("shoot"):
		shoot.emit(firing_point.global_position, mouse_dir)
		current_resources -= resources_per_shoot
		print(current_resources)
		update_current_level()

func  _physics_process(_delta):
	if dead:
		return
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_dir * move_speed
	move_and_slide()

func _on_health_changed(_previous_health, _current_health):
	GameEvents.on_player_health_changed.emit()

func kill():
	if dead:
		return
	dead = true
	GameEvents.on_player_died.emit()

func ReceiveDamage(attack: Attack):
	health.damage(attack.damage)
	GameEvents.on_player_health_changed.emit()
	if health.current_health <= 0.0:
		kill()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	print("get hit")

func update_current_level():
	if current_resources >= resources_to_level_up:
		var previous_resources: float = current_resources
		
		current_resources -= resources_to_level_up
		resources_to_level_up *= next_level_res_modifier
		current_level += 1
		
		GameEvents.on_player_level_changed.emit(current_level)
		
		print("Level changed: " + str(current_level))
	elif current_resources < 0:
		current_level -= 1


func collect_coin(pellet_resources: float):
	current_resources += pellet_resources
	update_current_level()

func _on_player_level_changed(lvl: int):
	print("New level")
	update_scales(size_inc)



func update_health_scale(t: float):
	var healthPercentage:float = inverse_lerp(0, health.max_health, health.current_health)
	health.max_health = lerp(max_health_cap, max_health_floor, t)
	health.current_health = lerp(0, health.max_health, healthPercentage)
	
	GameEvents.on_player_health_changed.emit()

func update_speed(t: float):
	move_speed = lerp(speed_cap, speed_floor, t)

func update_animation_scale():
	animated_sprite_2d.scale = Vector2(curr_scale, curr_scale);

func update_size_scale(t: float):
	curr_scale = update_current_scale_value(t)
	hitbox.scale = Vector2(curr_scale, curr_scale);
	collider_box.scale = Vector2(curr_scale, curr_scale);

func update_current_size_value(value: float):
	return clamp(current_size + value, size_floor, size_cap)

func update_current_scale_value(t: float):
	return lerp(scale_foor, scale_cap, t)

func update_camera_zoom(t: float):
	var current_zoom = camera.get_zoom()
	
	if camera.get_zoom().x >= zoom_floor:
		var new_zoom_value: float = lerp(zoom_cap, zoom_floor, update_current_scale_value(t)) * 2
		camera.set_zoom(Vector2(new_zoom_value, new_zoom_value))
	print(camera.get_zoom())
	print( lerp(zoom_cap, zoom_floor, update_current_scale_value(t)) * 2 )
	
	#camera.zoom = Vector2(inverse_lerp(zoom_floor, zoom_cap, current_zoom.x), inverse_lerp(zoom_floor, zoom_cap, current_zoom.y))

func update_scales(value: float):
	var t:float = inverse_lerp(size_floor, size_cap, current_size)
	current_size = update_current_size_value(value)
	
	update_size_scale(t)
	update_health_scale(t)
	update_speed(t)
	update_animation_scale()
	#update_camera_zoom(t)
