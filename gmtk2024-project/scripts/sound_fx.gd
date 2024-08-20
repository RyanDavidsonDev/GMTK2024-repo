extends Node

@onready var sound_players = get_children()

var active_players : Array[AudioStreamPlayer]

var sounds = {
	"hit": [
		load("res://assets-soundfx/hit 1.wav"),
		load("res://assets-soundfx/hit 2.wav"),
		load("res://assets-soundfx/hit 3.wav"),
	],
	"ammo": [
		load("res://assets-soundfx/pick up ammo.wav"),
	],
	"shoot": [
		load("res://assets-soundfx/bullet.wav"),
	],
	"explosion": [
		load("res://assets-soundfx/Tiny_Explosion.wav"),
		load("res://assets-soundfx/Explosion 2.wav"),
	],
	"heal": [
		load("res://assets-soundfx/Health_Collect.wav"),
	],
	"hit_barrel": [
		load("res://assets-soundfx/Barrel_hit.wav"),
	],
}

func play(sound_name):
	var array_sound_to_play = sounds[sound_name]
	
	if array_sound_to_play == null:
		return 
	
	var sound_to_play = array_sound_to_play[randi() % array_sound_to_play.size()]
	if sound_to_play == null:
		return 
	
	for sound_player : AudioStreamPlayer in sound_players:
		if sound_player.playing == false:
			sound_player.stream = sound_to_play
			sound_player.play()
			active_players.push_front(sound_player)
			sound_player.finished.connect(func() :active_players.pop_at(active_players.find(sound_player)))
			return
	
	for sound_player :AudioStreamPlayer in active_players :
		sound_player.stop()
		var index = active_players.find(sound_player)
		active_players.pop_at(index)
		sound_player.stream = sound_to_play
		sound_player.play()
		active_players.push_front(sound_player)
		sound_player.finished.connect(func() :active_players.pop_at(active_players.find(sound_player)))
		print("no sound player available, but we played from the oldest active player")
		return
		
	print("no sound player available. Too many sounds playing.")
