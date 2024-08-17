class_name Hitbox
extends Area2D


signal damaged(value: Attack)

func damage(attack: Attack):
	damaged.emit(attack)
