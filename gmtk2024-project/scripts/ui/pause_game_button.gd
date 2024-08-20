extends ScreenButton

func _on_mouse_entered() -> void:
	GameEvents.on_pause_button_hovered_state_changed.emit(true)

func _on_mouse_exited() -> void:
	GameEvents.on_pause_button_hovered_state_changed.emit(false)
