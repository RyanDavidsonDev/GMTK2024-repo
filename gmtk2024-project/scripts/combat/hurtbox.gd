class_name HurtBox
extends Node

@export var damage: float = 10.0

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		attack.damage = damage
		area.damage(attack)
