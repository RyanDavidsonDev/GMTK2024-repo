extends Node2D

@export var bullet_scene : PackedScene
@export var player: Player
@export var max_amount: int = 20

var pool: Pool

func _ready():
	pool = get_tree().get_first_node_in_group("pool")
	var bullet:Bullet
	
	for i in max_amount:
		bullet = bullet_scene.instantiate()
		
		#pool.add_to_non_active(bullet, "bullets")
		pool.add_child(bullet)
		bullet.hide()
	
	GameEvents.on_player_shoot.connect(_on_player_shoot)

func _on_player_shoot(pos: Vector2, dir:Vector2):
	var bullet: Bullet = pool.get_non_active_node_by_type("bullets")
	bullet.show()
	
	#print("spanwed")
	bullet.setVars(pos, dir)
	
	#add_to_group("bullets")
	pass
