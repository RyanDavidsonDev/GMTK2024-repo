extends Node2D

@export var bullet_scene : PackedScene

@export var player: Player

func _on_player_shoot(pos: Vector2, dir:Vector2):
	print("spanwed")
	var bullet:Bullet = bullet_scene.instantiate()
	add_child(bullet)
	
	bullet.setVars(pos, dir)
	
	add_to_group("bullets")

func _ready():	
	player = get_tree().get_first_node_in_group("player")
	player.shoot.connect(_on_player_shoot)
