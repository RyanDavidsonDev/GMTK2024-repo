extends TileMap

@export_group("chunk settings")
@export var chunk_width: int = 64
@export var chunk_height: int = 64


@export_group("noise_settings")
@export var noise: Noise

@onready var tile_map: TileMap = $TileMap

var generated_chunks: Array[Vector2i]

func _ready() -> void:
	pass


func generate_chunk(chunk_pos: Vector2i, width: int, height: int):
	var starter_pos: Vector2i = chunk_pos * Vector2i(width, height)
	
	for x in width:
		for y in height:
			var current_pos: Vector2i = Vector2i(starter_pos.x + width, starter_pos.y + height)
			var noise_val: float = noise.get_noise_2d(current_pos.x, current_pos.y)
			
			if noise_val < .1:
				pass
			else:
				pass
			print(x, y)
