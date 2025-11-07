extends Area2D

const SPEED = 500

func _ready() -> void:
	set_as_top_level(true)
	
	
func _process(delta: float) -> void:
	position += (Vector2.RIGHT*SPEED).rotated(rotation) * delta
	
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("player"):
		var player = area.get_parent()
		var attack_direction = (Vector2.RIGHT).rotated(rotation)
		
		if player.is_def:
			area.get_parent().take_damage(0)
		else:
			area.get_parent().take_damage(15 + global.current_attack_mult, attack_direction)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		queue_free()
