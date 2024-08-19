extends Node

@onready var layer1 : AudioStreamPlayer = $MusicLayer_1
@onready var layer2 : AudioStreamPlayer = $MusicLayer_2
@onready var layer3 : AudioStreamPlayer = $MusicLayer_3

var volume_off = -50.0
var volume_on = 0.0
var volume_change_speed = 5.0

var player : Player
var player_health_floor

var layer1_target_volume = 0.0
var layer2_target_volume = 0.0
var layer3_target_volume = 0.0

var _music_level : int = 0
var SMALL_LEVEL := 0
var MEDIUM_LEVEL := 1
var LARGE_LEVEL := 2 
	
func _ready():
	layer1_target_volume = volume_on
	layer1.volume_db = volume_on
	
	layer2_target_volume = volume_off
	layer3_target_volume = volume_off
	layer2.volume_db = volume_off
	layer3.volume_db = volume_off
	
	GameEvents.on_player_health_changed.connect(_on_player_health_changed)

func _process(delta: float):
	var speed = delta*volume_change_speed
	_move_volume_towards_target(speed, layer1, layer1_target_volume)
	_move_volume_towards_target(speed, layer2, layer2_target_volume)
	_move_volume_towards_target(speed, layer3, layer3_target_volume)

func _move_volume_towards_target(
	move_speed: float,
	stream : AudioStreamPlayer,
	volume_target: float):
	
	if !is_equal_approx(stream.volume_db, volume_target):
		stream.volume_db = lerp(stream.volume_db, volume_target, move_speed)
		if is_equal_approx(stream.volume_db, volume_target):
			stream.volume_db = volume_target

func _set_player():
	player = get_tree().get_first_node_in_group("player")
	return player != null

func _on_player_health_changed():
	if player == null:
		if _set_player() == false:
			return

	var player_health_upper_limit = float(player.max_health_floor * 0.85)
	var player_health_max = player.health.max_health
	
	var max_to_upper_limit_percentage = player_health_max / player_health_upper_limit
	
	var new_music_level = Music.SMALL_LEVEL
	
	if max_to_upper_limit_percentage < 0.20:
		layer2_target_volume = volume_off
		layer3_target_volume = volume_off
		new_music_level = Music.SMALL_LEVEL
	elif max_to_upper_limit_percentage < 0.30:
		layer2_target_volume = volume_on
		layer3_target_volume = volume_off
		new_music_level = Music.MEDIUM_LEVEL
	else:
		layer2_target_volume = volume_on
		layer3_target_volume = volume_on
		new_music_level = Music.LARGE_LEVEL
		
	if new_music_level != _music_level:
		_music_level = new_music_level
		GameEvents.on_music_level_changed.emit()
		
func get_level():
	return _music_level
