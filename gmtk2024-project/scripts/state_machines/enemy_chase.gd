extends EnemyState

@export var chase_speed := 75.0

func physics_update(delta: float):
	
	var direction := target.global_position - enemy.global_position
	
	var distance = direction.length()
	var enemy_chase_radius = enemy.chase_radius
	#print("chase distance", distance, "is greater than enemy chase radius", enemy_chase_radius, "? ", distance > enemy_chase_radius)
	enemy.last_direction = direction.normalized()
	if distance > enemy_chase_radius:
		transitioned.emit(self, "wander")
		return
	
	enemy.velocity = enemy.last_direction * chase_speed
	
	if distance <= enemy.follow_radius:
		enemy.velocity = Vector2.ZERO
	
	enemy.move_and_slide()
