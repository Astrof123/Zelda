extends Button

var speed_cost: String = str(0)

func _process(delta: float) -> void:
	speed_cost = str(int(global.speed_cost))
	update_text()

func update_text():
	text = speed_cost
