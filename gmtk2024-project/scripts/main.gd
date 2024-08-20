extends Node2D

@export var intro_story : SlideShow
@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

var is_game_paused := true
var trigger_pause_game := false

func _ready():
	screens.start_game.connect(_load_game)
	screens.unload_game.connect(_unload_game)
	screens.pause_game.connect(_pause_game)
	screens.resume_game.connect(_resume_game)
	GameEvents.on_player_died.connect(_end_game)
	intro_story.on_slide_reached_the_end.connect(_show_main_screen)
	intro_story.start_slide_show()

func _process(_delta: float) -> void:
	if trigger_pause_game:
		trigger_pause_game = false
		if game_scene_instance != null:
			game_scene_instance.process_mode = PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_game_paused:
			_resume_game()
		else:
			_pause_game()

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
	
func _show_main_screen():
	intro_story.queue_free()
	screens.show_main_screen()

func _pause_game():
	screens.show_pause_menu()
	get_tree().paused = true

func _resume_game():
	screens.show_hud()
	get_tree().paused = false
