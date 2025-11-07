extends Node2D


var is_destroyed = false

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	$StaticBody2D/CollisionPolygon2D.disabled = false

func destructible():
	pass
	
func destroy():
	if not is_destroyed:
		is_destroyed = true
		$AnimatedSprite2D.play("boom")
		$AnimationPlayer.play("disappear")
		global.coins += 3
		$StaticBody2D.queue_free()
