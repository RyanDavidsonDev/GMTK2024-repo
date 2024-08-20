class_name GameOverScreen
extends BaseScreen

@export var max_size_units : Label
@export var curr_size_units : Label
@export var highest_size_units : Label

func _ready():
	super._ready()
	
func set_score(max, curr, highest):
	max_size_units.text = max
	curr_size_units.text = curr
	highest_size_units.text = highest
