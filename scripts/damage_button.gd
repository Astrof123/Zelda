extends Button

var attack_cost: String = str(0)

func _process(delta: float) -> void:
	attack_cost = str(int(global.attack_cost))
	update_text()

func update_text():
	text = attack_cost
