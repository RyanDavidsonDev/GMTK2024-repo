extends ScreenButton

func _on_mouse_entered() -> void:
	GameEvents.on_supress_player_shoot.emit(1)

func _on_mouse_exited() -> void:
	GameEvents.on_supress_player_shoot.emit(-1)
