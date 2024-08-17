class_name ScreenButton
extends Node

func _on_pressed() -> void:
	ButtonEvents.button_pressed(self)
