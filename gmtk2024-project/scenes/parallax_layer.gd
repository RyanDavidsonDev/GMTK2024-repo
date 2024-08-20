extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size_changed.connect(update_mirroring)
	GameEvents
	pass # Replace with function body.


func update_mirroring():
	print("hi")
	motion_mirroring.x = get_viewport().size.x
	motion_mirroring.y = get_viewport().size.y
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
