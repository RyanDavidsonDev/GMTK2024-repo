extends EnemyState

var idle_timer : Timer

func _ready():
	super._ready()
	idle_timer = Timer.new()
	idle_timer.timeout.connect(on_timeout)
	idle_timer.one_shot = true
	add_child(idle_timer)

func enter():
	super.enter()
	enemy.velocity = Vector2.ZERO
	idle_timer.wait_time = randi_range(2, 5) * 0.1
	idle_timer.start()

func on_timeout():
	transitioned.emit(self, "wander")

func physics_update(_delta: float) -> void:
	try_chase()
	
func exit():
	super.exit()
	idle_timer.stop()
