extends Node2D

@export var intro_story : SlideShow
@export var quit_story : SlideShow
@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

var is_game_paused := false
var trigger_pause_game := false

var max_size_units
var curr_size_units
var highest_size_units_reached = 1

func _ready():
	screens.start_game.connect(_load_game)
	screens.unload_game.connect(_unload_game)
	screens.pause_game.connect(_pause_game)
	screens.resume_game.connect(_resume_game)
	screens.quit_game.connect(_quit_game)
	GameEvents.on_player_died.connect(_end_game)
	intro_story.on_slide_reached_the_end.connect(_show_main_screen)
	intro_story.start_slide_show()
	GameEvents.on_player_size_changed.connect(update_health_units)

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
	screens.show_gameover_screen(
		max_size_units,
		curr_size_units,
		highest_size_units_reached)
	
func _show_main_screen():
	intro_story.queue_free()
	screens.show_main_screen()

func _pause_game():
	screens.show_pause_menu()
	is_game_paused = true
	get_tree().paused = true

func _resume_game():
	screens.show_hud()
	is_game_paused = false
	get_tree().paused = false
	
func update_health_units(curr, max):
	curr_size_units = curr
	max_size_units = max
	highest_size_units_reached = max(curr_size_units, highest_size_units_reached)

func _quit_game():
	screens.hide_all()
	quit_story.start_slide_show()
	quit_story.on_slide_reached_the_end.connect(_actually_quit)

func _actually_quit():
	get_tree().quit()
