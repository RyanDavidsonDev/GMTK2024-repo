extends Node

@onready var main_screen = $MainMenu
@export var gameover_screen : GameOverScreen
@onready var pause_screen = $PauseMenu
@onready var hud_screen = null

signal start_game
signal unload_game
signal pause_game
signal resume_game

var current_screen = null

func _ready():
	ButtonEvents.on_btn_pressed.connect(_button_pressed)

func _button_pressed(btn : ScreenButton) -> void:
	print("button '", btn.name, "' press event received")
	match btn.name:
		"PlayGame":
			print("handling play game...")
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			start_game.emit()
			await(get_tree().create_timer(.65).timeout)
			show_hud()
		"QuitGame":
			get_tree().quit()
		"RetryGame":
			_resume_if_paused()
			unload_game.emit()
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			start_game.emit()
			await(get_tree().create_timer(.65).timeout)
			show_hud()
		"MainMenu":
			_resume_if_paused()
			unload_game.emit()
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			_change_screen(main_screen)
		"ContinueGame":
			_resume_if_paused()
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			show_hud()
			await(get_tree().create_timer(.65).timeout)
			resume_game.emit()
		"PauseGame":
			pause_game.emit()
		_:
			print("button '", btn.name, "' press unhandled")

func _change_screen(new_screen):
	if current_screen != null:
		var disappear_tween = current_screen.disapper()
		await(disappear_tween.finished)
		current_screen.visible = false
		
	current_screen = new_screen
	
	if current_screen != null:
		var appear_tween = current_screen.appear()
		await(appear_tween.finished)

func _resume_if_paused():
	if get_tree().paused:
				get_tree().paused = false

func show_gameover_screen():
	_change_screen(gameover_screen)
	gameover_screen.set_score("404","405","406")
	
func show_pause_menu():
	_change_screen(pause_screen)
	
func show_hud():
	if hud_screen == null:
		hud_screen = get_tree().get_first_node_in_group("hud")
		
	if hud_screen:
		_change_screen(hud_screen)

func show_main_screen():
	_change_screen(main_screen)
	
