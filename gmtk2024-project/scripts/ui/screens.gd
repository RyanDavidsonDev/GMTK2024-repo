extends Node

@onready var main_screen = $MainMenu

signal on_play_game_button_pressed

var current_screen = null

func _ready():
	change_screen(main_screen)
	ButtonEvents.on_btn_pressed.connect(_button_pressed)

func _button_pressed(btn : ScreenButton) -> void:
	print("button '", btn.name, "' press event received")
	match btn.name:
		"PlayGame":
			print("handling play game...")
			change_screen(null)
			await(get_tree().create_timer(.5).timeout)
			on_play_game_button_pressed.emit()
		"QuitGame":
			get_tree().quit()
		_:
			print("button '", btn.name, "' press unhandled")


func change_screen(new_screen):
	if current_screen != null:
		var disappear_tween = current_screen.disapper()
		await(disappear_tween.finished)
		current_screen.visible = false
		
	current_screen = new_screen
	
	if current_screen != null:
		var appear_tween = current_screen.appear()
		await(appear_tween.finished)
