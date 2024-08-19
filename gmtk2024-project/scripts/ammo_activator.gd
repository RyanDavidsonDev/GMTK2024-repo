extends Area2D

@export var move_to_target: Node2D
@export var health_follows := false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var attraction_curve :Curve 

var ammo_tracked : Dictionary = {}
var attract_speed : float = 250.0

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	if move_to_target == null:
		return

	var move_speed = delta*attract_speed
	for ammo:Node2D in ammo_tracked:
		if(collision_shape_2d.shape is CircleShape2D):
			#var circle_shape : CircleShape2D = collision_shape_2d.shape
			var circle_shape : CircleShape2D = collision_shape_2d.shape as CircleShape2D

			circle_shape.radius
			
			var center: Vector2 = self.global_position
			var pelletPos:Vector2 = ammo.global_position
			var magnetVector: Vector2 = pelletPos - center	
			
			#var strength : float =  lerp(circle_shape.radius, 0.0, magnetVector.length())
			var pct : float =  inverse_lerp(0.0, circle_shape.radius, magnetVector.length())
			var strength : float =  attraction_curve.sample_baked(pct)
			print("strength " + str(strength))
			move_speed =  move_speed* (1-strength)
		ammo.global_position = ammo.global_position.move_toward(
			move_to_target.global_position,
			move_speed)

func _on_area_entered(area: Area2D):
	if area is Pellet:
		if area.certain_type == "health" && !health_follows:
			return # ammo health does not follow target
		area.set_animation_speed_scale(3.0)
		ammo_tracked.get_or_add(area)
	
func _on_area_exited(area: Area2D):
	if area is Pellet:
		area.set_animation_speed_scale(1.0)
		ammo_tracked.erase(area)
