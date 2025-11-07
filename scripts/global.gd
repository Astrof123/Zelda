extends Node

# Статы врагов
var enemy_speed = 135

# ХП игроков
var player_max_health = 100
var player_current_health = 100

var player_current_attack = false
var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_pos_x = 416
var player_exit_cliffside_pos_y = 123

var player_start_pos_x = 135
var player_start_pos_y = 27


# Стартовые цены скиллов
var coins = 0
var speed_cost = 10
var money_cost = 10
var attack_cost = 10
var heal_cost = 10

# Множители цены скиллов
var speed_cost_mult = 1.5
var money_cost_mult = 1.5
var attack_cost_mult = 1.5
var heal_cost_mult = 1.5

# Множители статов 
var speed_up_mult = 15
var money_up_mult = 1.3
var attack_up_mult = 5
var max_health_up_mult = 10

# Статы 
var player_speed = 180
var current_coins_mult = 1
var current_attack_mult = 0

var game_first_loading = true



func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
