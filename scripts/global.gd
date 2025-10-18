extends Node

var player_current_attack = false
var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_pos_x = 416
var player_exit_cliffside_pos_y = 123

var player_start_pos_x = 135
var player_start_pos_y = 27


var game_first_loading = true

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
