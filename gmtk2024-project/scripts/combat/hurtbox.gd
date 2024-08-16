extends Node

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		area.damage(attack)
