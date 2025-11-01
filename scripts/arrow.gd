extends Area2D

const SPEED = 300

func _ready() -> void:
	set_as_top_level(true)
	
	
func _process(delta: float) -> void:
	position += (Vector2.RIGHT*SPEED).rotated(rotation) * delta
	
	

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("enemy"):
		var attack_direction = (Vector2.RIGHT).rotated(rotation)
		area.get_parent().take_damage(15, attack_direction)
		queue_free()
