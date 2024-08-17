extends Node

@onready var main_screen = $MainMenu
@onready var gameover_screen = $GameOver

signal start_game
signal unload_game

var current_screen = null

func _ready():
	_change_screen(main_screen)
	ButtonEvents.on_btn_pressed.connect(_button_pressed)

func _button_pressed(btn : ScreenButton) -> void:
	print("button '", btn.name, "' press event received")
	match btn.name:
		"PlayGame":
			print("handling play game...")
			_change_screen(null)
			await(get_tree().create_timer(.5).timeout)
			start_game.emit()
		"QuitGame":
			get_tree().quit()
		"RetryGame":
			unload_game.emit()
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			start_game.emit()
		"MainMenu":
			unload_game.emit()
			_change_screen(null)
			await(get_tree().create_timer(.65).timeout)
			_change_screen(main_screen)
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

func show_gameover_screen():
	_change_screen(gameover_screen)
