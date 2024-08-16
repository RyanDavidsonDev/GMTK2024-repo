extends EnemyState

@export var chase_speed := 75.0

func physics_update(delta: float):
	
	var direction := target.global_position - enemy.global_position
	
	var distance = direction.length_squared()
	if distance > enemy.chase_radius * enemy.chase_radius:
		transitioned.emit(self, "wander")
		return
	
	enemy.velocity = direction.normalized() * chase_speed
	
	if distance <= enemy.follow_radius * enemy.follow_radius:
		enemy.velocity = Vector2.ZERO
	
	enemy.move_and_slide()
