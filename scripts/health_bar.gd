extends TextureProgressBar

var player

func _ready() -> void:
	player = $"../../.."
	player.healthChanged.connect(update)
	update()
	
func update():
	value = player.currentHealth * 100 / player.maxHealth
