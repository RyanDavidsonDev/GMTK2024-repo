class_name Hitbox
extends Area2D


signal damaged(value: Attack)

func damage(attack: Attack):
	damaged.emit(attack)


func _on_body_entered(body: Node2D) -> void:
	print("player picked up pellet")
	pass # Replace with function body.
