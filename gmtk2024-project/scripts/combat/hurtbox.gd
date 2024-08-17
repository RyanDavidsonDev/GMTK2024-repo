extends Node

@export var damage: float = 10.0

@onready var timer: Timer = $Timer

var area_hit: bool = false

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var attack = Attack.new()
		attack.damage =damage
		area.damage(attack)
		timer.start()


func _on_timer_timeout() -> void:
	get_parent().hide()
	timer.stop()
