extends EnemyState

@export var min_wander_time := 2.5
@export var max_wander_time := 10.0
@export var wander_speed := 50.0

var wander_direction : Vector2

var wander_timer : Timer

func _ready():
	super._ready()
	wander_timer = Timer.new()
	wander_timer.timeout.connect(on_timeout)
	wander_timer.one_shot = true
	add_child(wander_timer)
	
func enter():
	super.enter()
	wander_direction = enemy.last_direction.rotated(deg_to_rad(randf_range(-45, 45)))
	wander_timer.wait_time = randf_range(min_wander_time, max_wander_time)

func physics_update(delta: float):
	enemy.velocity = wander_direction*wander_speed
	enemy.move_and_slide()
	
	try_chase()

func on_timeout():
	transitioned.emit(self, "idle")

func exit():
	super.exit()
	wander_timer.stop()
