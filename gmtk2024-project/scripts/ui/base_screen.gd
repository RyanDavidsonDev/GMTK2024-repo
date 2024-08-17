class_name BaseScreen
extends Control

var fade_duration = 0.5
var fade_property_path = "modulate:a"

func _ready():
	visible = false
	modulate.a = 0.0

func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, fade_property_path, 1.0, fade_duration)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	return tween
	
func disapper():
	var tween = get_tree().create_tween()
	tween.tween_property(self, fade_property_path, 0.0, fade_duration)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	return tween
