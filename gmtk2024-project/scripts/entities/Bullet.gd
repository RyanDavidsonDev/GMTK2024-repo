extends Area2D

class_name Bullet

@export var speed: float = 800
@export var direction: Vector2

@onready var timer: Timer = $Timer
@onready var hurt_box: Node = $Hurtbox
var damage_health: float

var pool: Pool

var active: bool

func _ready() -> void:
	pool = get_tree().get_first_node_in_group("pool")
	#hurt_box.dama

func setVars(pos: Vector2, dir:Vector2, scale:float, damage):
	global_position = pos
	direction = dir.normalized()
	hurt_box.damage = damage
	damage_health = damage
	self.scale = Vector2(scale, scale)
	global_rotation = dir.angle() + PI/2

func _physics_process(delta):
	position += speed *direction * delta
	pass
	#print("location" + str(transform))

func _on_area_entered(_area: Area2D) -> void:
	hide()

func deal_damage(amount: float) ->void:
	print("hurt")
	damage_health = max( damage_health - amount , 0)
	hurt_box.damage = damage_health
	if(damage_health <= 0):
		hide()
	

func _on_draw() -> void:
	pool.remove_from_non_active(self, "bullets")
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)
	set_deferred("active", true)
	set_deferred("process_mode", PROCESS_MODE_PAUSABLE)
	timer.start()

func _on_hidden() -> void:
	pool.add_to_non_active(self, "bullets")
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	set_deferred("active", false)
	set_deferred("process_mode", PROCESS_MODE_DISABLED)

func _on_timer_timeout() -> void:
	hide()


func _on_hurt_box_damage_dealt() -> void:
	pass # Replace with function body.
