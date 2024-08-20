extends Node

@onready var layer1 : AudioStreamPlayer = $MusicLayer_1
@onready var layer2 : AudioStreamPlayer = $MusicLayer_2
@onready var layer3 : AudioStreamPlayer = $MusicLayer_3

var volume_off = -50.0
var volume_on = 0.0
var toggle_track_duration = 1.25 # in seconds

var player : Player
var player_health_floor

var layer1_target_volume = 0.0
var layer2_target_volume = 0.0
var layer3_target_volume = 0.0

var _music_level : int = 0
var SMALL_LEVEL := 0
var MEDIUM_LEVEL := 1
var LARGE_LEVEL := 2 

var layer1_tween : Tween
var layer2_tween : Tween
var layer3_tween : Tween

func _ready():
	layer1_target_volume = volume_on
	layer1.volume_db = volume_on
	
	layer2_target_volume = volume_off
	layer3_target_volume = volume_off
	layer2.volume_db = volume_off
	layer3.volume_db = volume_off
	
	GameEvents.on_game_restarted.connect(_on_game_restarted)
	GameEvents.on_player_health_changed.connect(_on_player_health_changed)

func _set_player():
	player = get_tree().get_first_node_in_group("player")
	return player != null

func _on_game_restarted():
	for layer in [layer1, layer2, layer3]:
		layer.play(0)

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
		layer2_tween = _animate(
			layer2_tween,
			layer2,
			"volume_db",
			layer2_target_volume)
			
		layer3_tween = _animate(
			layer3_tween,
			layer3,
			"volume_db",
			layer3_target_volume)
			
		GameEvents.on_music_level_changed.emit()

func _animate(
	tween: Tween,
	object: Object,
	property: NodePath,
	final_val: Variant) -> Tween:
	
	if tween and (tween.is_valid() or tween.is_running()):
		tween.kill()
		tween = null
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		object,
		property,
		final_val,
		toggle_track_duration)

	return tween

func get_level():
	return _music_level
