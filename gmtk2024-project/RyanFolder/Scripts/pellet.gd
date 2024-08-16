extends Area2D

class_name Pellet

@export var speed: float  =300
@export var direction: Vector2

func _init(direction: Vector2):
	print("spawned, direction: " + str(direction))

func _physics_process(delta):
	
	position += speed *direction * delta
	pass
	#print("location" + str(transform))
