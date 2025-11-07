extends CharacterBody2D

const KNOCKBACK_FORCE = 400
const PLAYER_KNOCKBACK_FORCE = 350
const ATTACK_RANGE = 40
const ATTACK_COOLDOWN = 0.7

var player_chase = false
var player = null

var health = 100
var can_take_damage = true
var knockback_velocity = Vector2.ZERO
var can_attack = true
var dir = "right"

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	$SwordHit/CollisionShape2D.disabled = true
	call_deferred("actor_setup")

func actor_setup() -> void:
	await get_tree().physics_frame
	nav_agent.target_position = global_position

func _physics_process(delta: float) -> void:
	update_health()
	
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)
		return
	
	if not can_attack:
		return
	
	if player_chase and player != null:
		var distance_to_player = position.distance_to(player.position)
		
		nav_agent.target_position = player.global_position
		
		var next_path_position = nav_agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
			dir = "left"
		else:
			$AnimatedSprite2D.flip_h = false
			dir = "right"
		
		if distance_to_player <= ATTACK_RANGE and can_attack:
			attack()
		elif distance_to_player > ATTACK_RANGE:
			velocity = direction * global.enemy_speed
			move_and_slide()
			$AnimatedSprite2D.play("side_walk")
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("side_idle")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("side_idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
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
			global.coins += int(25 * global.current_coins_mult)
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

func attack():
	if can_attack:
		can_attack = false
		$AnimatedSprite2D.play("attack")
		
		if (dir == "left"):
			$AnimationPlayer.play("attack_left")
		else:
			$AnimationPlayer.play("attack")
	
		$AttackCooldown.start(ATTACK_COOLDOWN)

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("player"):
		var player_node = area.get_parent()
		var attack_direction = (player_node.global_position - global_position).normalized()
		
		if player_node.is_def == true:
			apply_knockback(-attack_direction)
			player_node.take_damage(5)
		else:
			player_node.take_damage(25, attack_direction)
