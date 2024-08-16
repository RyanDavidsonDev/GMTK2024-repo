extends EnemyState

var idle_timer : Timer

func _ready():
	super._ready()
	idle_timer = Timer.new()
	idle_timer.timeout.connect(on_timeout)
	idle_timer.one_shot = true
	add_child(idle_timer)

func enter():
	enemy.velocity = Vector2.ZERO
	idle_timer.wait_time = randi_range(3, 10)
	idle_timer.start()

func on_timeout():
	transitioned.emit(self, "wander")

func physics_update(delta: float) -> void:
	try_chase()
	
func exit():
	idle_timer.stop()
