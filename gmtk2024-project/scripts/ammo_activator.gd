extends Area2D

@export var move_to_target: Node2D
@export var health_follows := false

var ammo_tracked : Dictionary = {}
var attract_speed : float = 50.0

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	if move_to_target == null:
		return

	var move_speed = delta*attract_speed
	for ammo in ammo_tracked:
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
