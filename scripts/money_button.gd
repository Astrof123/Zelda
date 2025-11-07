extends Button

var money_cost: String = str(0)

func _process(delta: float) -> void:
	money_cost = str(int(global.money_cost))
	update_text()

func update_text():
	text = money_cost
