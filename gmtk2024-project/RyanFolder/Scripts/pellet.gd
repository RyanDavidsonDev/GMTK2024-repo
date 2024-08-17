extends Area2D

class_name Pellet

@export var speed: float  =300
@export var direction: Vector2

func _init():
	print("spawned, direction: " + str(direction))
	


func setVars(pos: Vector2, dir:Vector2):
	
	global_position = pos
	direction = dir.normalized()
	global_rotation = dir.angle() + PI/2

func _physics_process(delta):
	
	position += speed *direction * delta
	pass
	#print("location" + str(transform))


func _on_area_entered(area: Area2D) -> void:
	queue_free()
