extends BaseScreen

@export_group("health bar", "health_")
@export var health_bar : TextureProgressBar
@export var health_bar_label : Label
@export var health_danger_color : Color
@export var health_normal_color : Color
@export var health_medium_color : Color
@export var health_large_color : Color

var player : Player

var viewport_size
var min_health_bar_window_size = 0.0
var max_health_bar_window_size = 0.0

var base_color : Color
var is_in_danger := false
var music_level := Music.SMALL_LEVEL
var health_bar_color : Color

# tweens
var health_bar_size_tween : Tween
var health_current_value_tween : Tween
var health_max_value_tween : Tween
var health_bar_label_tween : Tween
var health_bar_progress_color : Tween
var anim_duration = 0.75 # in seconds

func _ready():
	super._ready()
	
	base_color = health_normal_color
		
	_set_player()
	_on_music_level_changed()
	_update_targets()
	
	_on_viewport_size_changed()
	
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	GameEvents.on_player_health_changed.connect(_update_targets)
	GameEvents.on_music_level_changed.connect(_on_music_level_changed)

func _set_player():
	player = get_tree().get_first_node_in_group("player")
	return player != null

func _update_targets():
	_update_health_bar_size()
	_update_health_bar_values()
	_update_health_label()
	_update_health_bar_color()

func _update_health_label():
	if player == null:
		if _set_player() == false:
			return
			
	health_bar_label.text = "%.2f / %.2f" % [player.health.current_health, player.health.max_health]

func _update_health_bar_color():
	
	var target_color = base_color
	if is_in_danger:
		target_color = health_danger_color
	
	if health_bar.tint_progress.is_equal_approx(target_color):
		health_bar.tint_progress = target_color
	else:
		health_bar_progress_color = _animate(
			health_bar_progress_color,
			health_bar,
			"tint_progress",
			target_color)

func _update_health_bar_values():
	if player == null:
		if _set_player() == false:
			return
	
	health_max_value_tween = _animate(
		health_max_value_tween,
		health_bar,
		"max_value",
		player.health.max_health)
	
	health_current_value_tween = _animate(
		health_current_value_tween,
		health_bar,
		"value",
		player.health.current_health)
		
	is_in_danger = player.health.current_health < 9.9

func _update_health_bar_size():
	if player == null:
		if _set_player() == false:
			return

	var health_bar_size_percentage = inverse_lerp(
		player.max_health_cap,
		player.max_health_floor,
		player.health.max_health)
	
	var health_bar_window_size = lerp(
		min_health_bar_window_size,
		max_health_bar_window_size,
		health_bar_size_percentage) 
	
	health_bar_size_tween = _animate(
		health_bar_size_tween,
		health_bar,
		"size:x",
		health_bar_window_size)

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
		anim_duration)

	return tween

func _on_viewport_size_changed():
	viewport_size = get_viewport_rect().size
	min_health_bar_window_size = 120.0
	max_health_bar_window_size = viewport_size.x * 0.5
	_update_health_bar_size()

func _on_music_level_changed():
	match Music.get_level():
		Music.SMALL_LEVEL:
			base_color = health_normal_color
		Music.MEDIUM_LEVEL:
			base_color = health_medium_color
		Music.LARGE_LEVEL:
			base_color = health_large_color
			
	_update_targets()
