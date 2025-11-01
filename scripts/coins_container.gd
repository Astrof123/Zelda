extends VBoxContainer

@onready var coin_display = $CoinsCount

var coins: String = str(0)

func _process(delta: float) -> void:
	coins = str(global.coins)
	update_text()


func update_text():
	coin_display.text = coins
