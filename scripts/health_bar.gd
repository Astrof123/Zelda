extends TextureProgressBar

var player

func _ready() -> void:
	player = $"../.."
	player.healthChanged.connect(update)
	update()
	
func update():
	value = global.player_current_health * 100 / global.player_max_health
	max_value = global.player_max_health
