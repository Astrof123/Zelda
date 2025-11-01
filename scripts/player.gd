extends CharacterBody2D

signal healthChanged


var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true

const KNOCKBACK_FORCE = 200
var current_dir = "none"

var attack_ip = false

var bow_equired = true
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
@export var maxHealth = 100
var currentHealth: int = 100
var knockback_velocity = Vector2.ZERO


func _ready() -> void:
	$AnimatedSprite2D.play("frond_idle")


func _physics_process(delta: float) -> void:
	player_movement(delta)
	attack()
	current_camera()
	
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)  # Плавное замедление
		return
	
	if currentHealth <= 0:
		player_alive = false
		currentHealth = 0
		self.queue_free()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equired and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		$"..".add_child(arrow_instance)
		
		await get_tree().create_timer(0.8).timeout
		bow_cooldown = true
		
	
func player_movement(delta):
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = global.player_speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -global.player_speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = global.player_speed
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -global.player_speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	elif dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	elif dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("frond_idle")
	elif dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")	


func player():
	pass


func apply_knockback(direction: Vector2):
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	knockback_velocity = direction * KNOCKBACK_FORCE


func take_damage(damage, attack_direction: Vector2 = Vector2.ZERO):
	if enemy_attack_cooldown == true:
		currentHealth -= damage
		apply_knockback(attack_direction)
		
		healthChanged.emit()
		enemy_attack_cooldown = false
		$AttackCooldown.start()
		

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$DealAttackTimer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$DealAttackTimer.start()
		elif dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$DealAttackTimer.start()
		elif dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$DealAttackTimer.start()

func _on_deal_attack_timer_timeout() -> void:
	$DealAttackTimer.stop()
	global.player_current_attack = false
	attack_ip = false


func current_camera():
	if global.current_scene == "world":
		$WorldCamera.enabled = true
		$CliffsideCamera.enabled = false
		
	elif global.current_scene == "cliff_side":
		$WorldCamera.enabled = false
		$CliffsideCamera.enabled = true
		
