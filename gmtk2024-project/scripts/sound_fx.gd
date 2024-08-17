extends Node

@onready var sound_players = get_children()

var sounds = {
	"Click": [
		#load("res://assets/sound/Click.wav")
	],
	"Shoots": [
		#load("res://assets/sound/Shoot_000.wav"),
		#load("res://assets/sound/Shoot_001.wav"),
		#load("res://assets/sound/Shoot_002.wav"),
		#load("res://assets/sound/Shoot_003.wav"),
	],
	"PlayerDies": [
		#load("res://assets/sound/PlayerDies.wav")
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
