extends Node2D

@onready var screens = $Screens
@onready var game_scene = load("res://scenes/game.tscn")

var game_scene_instance : Node

func _ready():
	screens.on_play_game_button_pressed.connect(_load_game)

func _load_game():
	print("load game")
	if game_scene_instance:
		game_scene_instance.queue_free()

	game_scene_instance = game_scene.instantiate()
	add_child(game_scene_instance)
