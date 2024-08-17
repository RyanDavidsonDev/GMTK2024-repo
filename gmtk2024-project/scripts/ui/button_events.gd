extends Node

signal on_btn_pressed(btn : ScreenButton)

func button_pressed(btn : ScreenButton):
	on_btn_pressed.emit(btn)
