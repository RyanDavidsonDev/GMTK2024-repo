extends Node2D

@export var pellet_scene : PackedScene

@export var player: Player

func _on_player_shoot(pos: Vector2, dir:Vector2):
	print("spanwed")
	var pellet:Pellet = pellet_scene.instantiate()
	add_child(pellet)
	
	pellet.setVars(pos, dir)
	
	add_to_group("bullets")

func _ready():	
	player = get_tree().get_first_node_in_group("player")
	player.shoot.connect(_on_player_shoot)
