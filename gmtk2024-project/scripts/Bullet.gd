extends Area2D

class_name Bullet

@export var speed: float = 800
@export var direction: Vector2

@onready var timer: Timer = $Timer

var pool: Pool

var active: bool

func _ready() -> void:
	pool = get_tree().get_first_node_in_group("pool")

#func _init():
	#print("spawned, direction: " + str(direction))
	#
	#

func setVars(pos: Vector2, dir:Vector2):
	
	global_position = pos
	direction = dir.normalized()
	global_rotation = dir.angle() + PI/2

func _physics_process(delta):
	print("speed: " + str(speed))
	position += speed *direction * delta
	pass
	#print("location" + str(transform))

func _on_area_entered(area: Area2D) -> void:
	hide()

func _on_draw() -> void:
	pool.remove_from_non_active(self, "bullets")
	monitorable = true
	monitoring = true
	active = true
	timer.start()

func _on_hidden() -> void:
	pool.add_to_non_active(self, "bullets")
	monitorable = false
	monitoring = false
	active = false


func _on_timer_timeout() -> void:
	hide()
