# warnings-disable
extends Node

signal on_player_shoot(position: Vector2, direction: Vector2, scale: float)
signal on_player_died
signal on_player_health_changed
signal on_enemy_explode(location:Vector2)
signal on_music_level_changed
signal on_supress_player_shoot(increment:int)
signal on_player_size_changed(curr :float, max: float)
