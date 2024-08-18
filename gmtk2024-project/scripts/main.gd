extends Node2D

@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

var trigger_pause_game := false

func _ready():
	screens.start_game.connect(_load_game)
	screens.unload_game.connect(_unload_game)
	GameEvents.on_player_died.connect(_end_game)

func _process(_delta: float) -> void:
	if trigger_pause_game:
		if game_scene_instance != null:
			game_scene_instance.process_mode = PROCESS_MODE_DISABLED

func _load_game():
	_unload_game()
	game_scene_instance = game_scene.instantiate()
	game_scene_instance.process_mode = PROCESS_MODE_PAUSABLE
	add_child(game_scene_instance)

func _unload_game():
	if game_scene_instance:
		game_scene_instance.queue_free()
		game_scene_instance = null

func _end_game():
	trigger_pause_game = true
	screens.show_gameover_screen()
