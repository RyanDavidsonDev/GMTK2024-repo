extends Area2D

var active: bool

var pool: Pool

func _ready() -> void:
	pool = get_tree().get_first_node_in_group("pool")
	
	active = true

func _on_body_entered(body: Node2D) -> void:
	print("player collected coin")
	if body is Player:
		print("player")
		body.collect_coin()
		
		hide()


func _on_draw() -> void:
	pool.remove_from_non_active(self, "pellets")
	pool.add_to_non_active(self, "a_pellets")
	monitorable = true
	monitoring = true
	active = true


func _on_hidden() -> void:
	pool.add_to_non_active(self, "pellets")
	pool.remove_to_non_active(self, "a_pellets")
	monitorable = false
	monitoring = false
	active = false
