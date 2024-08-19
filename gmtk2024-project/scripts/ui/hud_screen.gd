extends BaseScreen

@export_group("health bar", "health_")
@export var health_bar : TextureProgressBar
@export var health_bar_label : Label
@export var health_danger_color : Color
@export var health_normal_color : Color
@export var health_medium_color : Color
@export var health_large_color : Color

var change_animation_speed = 10.0

var player : Player
var player_health_floor = 0.0
var player_health_cap = 0.0
var player_health_max : float = 0.0
var player_health_current : float = 0.0

var viewport_size
var min_health_bar_window_size = 0.0
var max_health_bar_window_size = 0.0

var target_player_health_current : float = 0
var target_player_health_max : float = 0

var health_bar_color : Color
var target_health_bar_color : Color
var base_color : Color

func _ready():
	super._ready()
	GameEvents.on_player_health_changed.connect(_update_targets)
	GameEvents.on_music_level_changed.connect(_on_music_level_changed)
	
	base_color = health_normal_color
	target_health_bar_color = base_color;
	
	_set_player()
	_on_music_level_changed()
	_update_targets()
	
	_on_viewport_size_changed()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_update_health_components()
	
func _process(_delta:float):
	if !is_equal_approx(target_player_health_current,player_health_current):
		var direction = sign(target_player_health_current - player_health_current)
		player_health_current += direction*_delta*change_animation_speed
		if is_zero_approx(int(target_player_health_current) - int(player_health_current)):
			target_player_health_current = player_health_current
		_update_health_components()
	
	if !is_equal_approx(target_player_health_max, player_health_max):
		var direction = sign(target_player_health_max - player_health_max)
		player_health_max += direction*_delta*change_animation_speed
		if is_zero_approx(int(target_player_health_max) - int(player_health_max)):
			target_player_health_max = player_health_max
		_update_health_components()
		
	if !is_same(target_health_bar_color, health_bar_color):
		health_bar_color = health_bar_color.lerp(target_health_bar_color, _delta*change_animation_speed)
		if health_bar_color.is_equal_approx(target_health_bar_color):
			health_bar_color = target_health_bar_color
			_update_health_components()

func _update_health_components():
	
	var health_bar_size_percentage = inverse_lerp(
		player_health_cap,
		player_health_floor,
		player_health_max)
	
	var health_bar_window_size = lerp(
		min_health_bar_window_size,
		max_health_bar_window_size,
		health_bar_size_percentage) #hard coding this as I don't think we need the size of the  bar to change
	
	health_bar.size.x = health_bar_window_size
	health_bar.max_value = player_health_max
	health_bar.value = player_health_current
	
	#print(" ---- current health" + str(player_health_current))
	#health_label.text = str(snapped(player_health_current, .01)) + " / " + str(int(ceil(player_health_max)))
	health_bar_label.text = "%.2f / %.2f" % [player_health_current, player_health_max]
	
	health_bar.tint_progress = health_bar_color

func _update_targets():
	if player == null:
		if _set_player() == false:
			return
	
	player_health_floor = float(player.max_health_floor)
	player_health_cap = float(player.max_health_cap)

	target_player_health_max = player.health.max_health
	target_player_health_current = player.health.current_health
	
	if target_player_health_current <= 9.9:
		target_health_bar_color = health_danger_color
	else:
		target_health_bar_color = base_color
	
func _set_player():
	player = get_tree().get_first_node_in_group("player")
	return player != null

func _on_viewport_size_changed():
	viewport_size = get_viewport_rect().size
	min_health_bar_window_size = 120.0
	max_health_bar_window_size = viewport_size.x * 0.5
	_update_targets()

func _on_music_level_changed():
	match Music.get_level():
		Music.SMALL_LEVEL:
			base_color = health_normal_color
		Music.MEDIUM_LEVEL:
			base_color = health_medium_color
		Music.LARGE_LEVEL:
			base_color = health_large_color
			
	_update_targets()
