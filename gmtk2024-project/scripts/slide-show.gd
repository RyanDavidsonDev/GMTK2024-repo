class_name SlideShow
extends Node

@export var fade_duration := 0.5
@export var current_slide : TextureRect
@export var next_slide : TextureRect
@export var slides : Array[Texture]

signal on_slide_reached_the_end

var slide_index := 0

var slide_hidden = 0.0
var slide_shown = 1.0
var modulate_alpha_property = "modulate:a"

var can_change_slides: = false
func _ready():
	current_slide.mouse_default_cursor_shape = Control.CURSOR_ARROW
	current_slide.modulate.a = slide_hidden
	next_slide.modulate.a = slide_hidden
	can_change_slides = false
	
func _process(_delta):
	if false == can_change_slides:
		return

	if Input.is_action_just_pressed("slide_next"):
		_advance_slide()
	elif Input.is_action_just_pressed("slide_previous"):
		_go_to_previous_slide()
		
func _advance_slide():
	slide_index += 1
	if slide_index >= slides.size():
		slide_index = slides.size()-1
		_complete_slide_show()
	else:
		_update_slide()
	
func _go_to_previous_slide():
	slide_index -= 1
	if slide_index < 0:
		slide_index = 0
	_update_slide()

func _update_slide():
	can_change_slides = false
	next_slide.texture = slides[slide_index]
	
	var tween = get_tree().create_tween()
	tween.tween_property(next_slide, modulate_alpha_property, slide_shown, fade_duration)
	await(tween.finished)
	current_slide.texture = next_slide.texture
	next_slide.modulate.a = slide_hidden
	
	can_change_slides = true
	
func _complete_slide_show():
	current_slide.mouse_default_cursor_shape = Control.CURSOR_ARROW
	var tween = get_tree().create_tween()
	tween.tween_property(current_slide, modulate_alpha_property, slide_hidden, fade_duration)
	await(tween.finished)
	on_slide_reached_the_end.emit()
	
func start_slide_show():
	slide_index = 0
	current_slide.texture = slides[slide_index]
	var tween = get_tree().create_tween()
	tween.tween_property(current_slide, modulate_alpha_property, slide_shown, fade_duration)
	await(tween.finished)
	current_slide.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	can_change_slides = true
