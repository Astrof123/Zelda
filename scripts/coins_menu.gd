extends MarginContainer

@export var speed_button: Button
@export var money_button: Button


func _on_speed_pressed() -> void:
	if global.coins > global.speed_cost:
		global.coins -= global.speed_cost
		global.player_speed += 30
		speed_button.text = str(global.speed_cost + 10)
		global.speed_cost += 10
		
