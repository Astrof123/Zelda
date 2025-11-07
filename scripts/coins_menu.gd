extends MarginContainer

@export var speed_button: Button
@export var money_button: Button


func _on_speed_pressed() -> void:
	if global.coins > global.speed_cost:
		global.coins -= global.speed_cost
		global.player_speed += global.speed_up_mult
		global.speed_cost = global.speed_cost * global.speed_cost_mult
		


func _on_money_pressed() -> void:
	if global.coins > global.money_cost:
		global.coins -= global.money_cost
		global.current_coins_mult *= global.money_up_mult
		global.money_cost = global.money_cost * global.money_cost_mult


func _on_heal_pressed() -> void:
	if global.coins > global.heal_cost:
		global.coins -= global.heal_cost
		global.player_max_health += global.max_health_up_mult
		global.player_current_health += int(global.player_current_health / 2.0)
		global.heal_cost = global.heal_cost * global.heal_cost_mult


func _on_attack_pressed() -> void:
	if global.coins > global.attack_cost:
		global.coins -= global.attack_cost
		global.current_attack_mult += global.attack_up_mult
		global.attack_cost = global.attack_cost * global.attack_cost_mult
