extends Button

var heal_cost: String = str(0)

func _process(delta: float) -> void:
	heal_cost = str(int(global.heal_cost))
	update_text()

func update_text():
	text = heal_cost
