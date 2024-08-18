extends BaseScreen

@export var health_bar : TextureProgressBar
@export var health_label : Label

var player : Player
var player_health_floor = 0.0
var player_health_cap = 0.0
var player_health_max : float= 0.0
var player_health_current : float = 0.0

var viewport_size
var min_health_bar_window_size = 0.0
var max_health_bar_window_size = 0.0

var target_player_health_current : float = 0
var target_player_health_max : float = 0

func _ready():
	super._ready()
	GameEvents.on_player_health_changed.connect(_update_player_health)
	_set_player()
	_update_player_health()
	
	_on_viewport_size_changed()
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_update_health_components()
	
func _process(_delta:float):
	
	if target_player_health_current != player_health_current:
		target_player_health_current = player_health_current
		#var direction = sign(target_player_health_current - player_health_current)
		#player_health_current += direction
		_update_health_components()
	
	if target_player_health_max != player_health_max:
		target_player_health_max = player_health_max
		#var direction = sign(target_player_health_max - player_health_max)
		#player_health_max += direction
		
		_update_health_components()

func _update_health_components():
	
	var health_bar_size_percentage = inverse_lerp(
		player_health_floor,
		player_health_cap,
		player_health_max)

	var health_bar_window_size = lerp(
		min_health_bar_window_size,
		max_health_bar_window_size,
		1) #hard coding this as I don't think we need the size of the  bar to change
	
	
	health_bar.size.x = 576
	
	health_bar.max_value = player_health_max
	health_bar.value = player_health_current
	
	#print(" ---- current health" + str(player_health_current))
	health_label.text = str(snapped(player_health_current, .01)) + " / " + str(int(ceil(player_health_max)))
	#health_label.text = "%.1f / %.1f" % [player_health_current, player_health_max]

func _update_player_health():
	if player == null:
		if _set_player() == false:
			return
	
	player_health_floor = float(player.max_health_floor)
	player_health_cap = float(player.max_health_cap)

	player_health_max = player.health.max_health
	player_health_current = player.health.current_health

func _set_player():
	player = get_tree().get_first_node_in_group("player")
	return player != null

func _on_viewport_size_changed():
	viewport_size = get_viewport_rect().size
	min_health_bar_window_size = viewport_size.x * 0.2
	max_health_bar_window_size = viewport_size.x * 0.5
	_update_player_health()
