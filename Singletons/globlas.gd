extends Node

var coins := 0
var count_coins := 0
var score := 0
var player_life := 3

var player = null
var player_start_position = null
var current_checkpoint = null

func respawn_player():
	player.z_index = 10
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
