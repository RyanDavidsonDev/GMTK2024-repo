extends Node

@onready var sound_players = get_children()

var sounds = {
	"hit": [
		load("res://assets-soundfx/hit 1.mp3"),
		load("res://assets-soundfx/hit 2.mp3"),
		load("res://assets-soundfx/hit 3.mp3"),
	],
	"ammo-pickup": [
		load("res://assets-soundfx/pick up ammo.mp3"),
	],
	"shoot": [
		load("res://assets-soundfx/bullet.mp3"),
	],
	"explosion": [
		load("res://assets-soundfx/Tiny_Explosion.mp3"),
		load("res://assets-soundfx/Explosion 2.mp3"),
	],
	"heal": [
		load("res://assets-soundfx/Health_Collect.mp3"),
	],
}

func play(sound_name):
	var array_sound_to_play = sounds[sound_name]
	
	if array_sound_to_play == null:
		return 
	
	var sound_to_play = array_sound_to_play[randi() % array_sound_to_play.size()]
	if sound_to_play == null:
		return 
	
	for sound_player in sound_players:
		if sound_player.playing == false:
			sound_player.stream = sound_to_play
			sound_player.play()
			return
			
	print("no sound player available. Too many sounds playing.")
