extends Node2D

@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

var trigger_pause_game := false

func _ready():
	screens.start_game.connect(_load_game)
	screens.unload_game.connect(_unload_game)
	screens.continue_game.connect(_continue_game)
	#GameEvents.on_game_paused.connect(_pause_game)
	GameEvents.on_player_died.connect(_end_game)

func _process(_delta: float) -> void:
	if trigger_pause_game:
		trigger_pause_game = false
		if game_scene_instance != null:
			game_scene_instance.process_mode = PROCESS_MODE_DISABLED

func _continue_game():
	#game_scene_instance.process_mode = PROCESS_MODE_PAUSABLE
	SceneStateManager.set_scene_state(game_scene_instance, "resumed")
	get_tree().paused = false

#func _pause_game():
	#game_scene_instance.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	#GameEvents.on_game_paused.emit()
	#screens.show_pause_screen()

func _load_game():
	_unload_game()
	game_scene_instance = game_scene.instantiate()
	add_child(game_scene_instance)

func _unload_game():
	if game_scene_instance:
		game_scene_instance.queue_free()
		game_scene_instance = null

func _end_game():
	trigger_pause_game = true
	screens.show_gameover_screen()

func _input(event: InputEvent) -> void:
	#add toggle for if already paused
	#pause music
	if Input.is_action_just_pressed("pause") and SceneStateManager.get_scene_state(game_scene_instance) != "paused":
		SceneStateManager.set_scene_state(game_scene_instance, "paused")
		screens.show_pause_screen()
		print(SceneStateManager.get_scene_state_raw(game_scene_instance))
		print(SceneStateManager.get_scene_state(game_scene_instance))
		GameEvents.on_game_paused.emit()
		#_pause_game()
