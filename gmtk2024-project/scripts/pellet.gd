extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("player collected coin")
	if body is Player:
		print("player")
		body.collect_coin()
		queue_free()
