extends CharacterBody2D

const SPEED = 40
const KNOCKBACK_FORCE = 200
const PLAYER_KNOCKBACK_FORCE = 150  # Сила отталкивания игрока

var player_chase = false
var player = null

var health = 100
var can_take_damage = true
var knockback_velocity = Vector2.ZERO


func _physics_process(delta: float) -> void:
	update_health()
	
	# Обработка отталкивания
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)  # Плавное замедление
		return
	
	if player_chase:
		position += (player.position - position) / SPEED
		$AnimatedSprite2D.play("side_walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
			
	else:
		$AnimatedSprite2D.play("side_idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass

func take_damage(damage, attack_direction: Vector2 = Vector2.ZERO):
	if can_take_damage == true:
		health -= damage
		
		apply_knockback(attack_direction)
			
		$TakeDamageCooldown.start()
		can_take_damage = false
		if health <= 0:
			global.coins += 25
			self.queue_free()

func apply_knockback(direction: Vector2):
	if direction == Vector2.ZERO and player != null:
		direction = (global_position - player.global_position).normalized()
	
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	knockback_velocity = direction * KNOCKBACK_FORCE

func _on_take_damage_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("player"):
		# Вычисляем направление от врага к игроку для отталкивания
		var player_node = area.get_parent()
		var attack_direction = (player_node.global_position - global_position).normalized()
		player_node.take_damage(15, attack_direction)
