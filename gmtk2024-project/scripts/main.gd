extends Node2D

@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

func _ready():
	screens.start_game.connect(_load_game)
	screens.unload_game.connect(_unload_game)
	GameEvents.on_player_died.connect(_end_game)

func _load_game():
	_unload_game()
	game_scene_instance = game_scene.instantiate()
	add_child(game_scene_instance)

func _unload_game():
	if game_scene_instance:
		game_scene_instance.queue_free()
		game_scene_instance = null

func _end_game():
	game_scene_instance.process_mode = PROCESS_MODE_DISABLED
	screens.show_gameover_screen()
