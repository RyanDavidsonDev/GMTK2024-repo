class_name Hitbox
extends Area2D


signal damaged(value: Attack)

func damage(attack: Attack):
	damaged.emit(attack)


func _on_body_entered(_body: Node2D) -> void:
	print("player touched enemy")
	pass # Replace with function body.
