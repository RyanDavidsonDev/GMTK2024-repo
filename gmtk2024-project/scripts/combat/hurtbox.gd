class_name HurtBox
extends Area2D

@export var damage: float = 10.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	#retrieve reference to other area and send damage signal
	#ie hurtbox deals
	if area is Hitbox:
		print("hurbox entered")
		var attack = Attack.new()
		attack.damage = damage
		area.damage(attack)
