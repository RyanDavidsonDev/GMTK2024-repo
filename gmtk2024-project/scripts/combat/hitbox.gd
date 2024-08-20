class_name Hitbox
extends Area2D

signal damaged(value: Attack, origin : Hurtbox)

func damage(attack: Attack, origin: Hurtbox):
	#hitbox receives
	damaged.emit(attack, origin)

func _on_body_entered(_body: Node2D) -> void:
	print("player touched enemy")
	pass # Replace with function body.
