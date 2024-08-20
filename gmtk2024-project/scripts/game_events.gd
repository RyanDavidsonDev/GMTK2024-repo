
extends Node

@warning_ignore("unused_signal")
signal on_player_shoot(position: Vector2, direction: Vector2, scale: float)

@warning_ignore("unused_signal")
signal on_player_died

@warning_ignore("unused_signal")
signal on_player_health_changed

@warning_ignore("unused_signal")
signal on_enemy_explode(location:Vector2)

@warning_ignore("unused_signal")
signal on_music_level_changed

@warning_ignore("unused_signal")
signal on_game_restarted

@warning_ignore("unused_signal")
signal on_supress_player_shoot(increment:int)
signal on_player_size_changed(curr :float, max: float)
signal zoom_updatedd
