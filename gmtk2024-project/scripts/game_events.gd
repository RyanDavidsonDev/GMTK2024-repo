# warnings-disable
extends Node

signal on_player_shoot(position: Vector2, direction: Vector2)
signal on_player_died
signal on_player_health_changed
signal on_enemy_explode(location:Vector2)
signal on_music_level_changed
signal on_game_paused
signal on_game_resumed
signal on_pause_button_hovered_state_changed(is_hovered:bool)
