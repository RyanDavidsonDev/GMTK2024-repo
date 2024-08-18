extends Node
###
## this together effects (sounds, graphics animation)
###
var player : Player

func _ready():
	GameEvents.on_enemy_explode.connect(_on_enemy_exploded)

func _is_available_player():
	if player == null:
		player = get_tree().get_first_node_in_group("player")

	return player != null

func _on_enemy_exploded(_location):
	SoundFx.play("explosion")
