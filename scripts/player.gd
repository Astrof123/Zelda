extends CharacterBody2D

signal healthChanged


var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true

const KNOCKBACK_FORCE = 400
var current_dir = "none"

var attack_ip = false
var is_def = false

var bow_equired = false
var arrow = preload("res://scenes/arrow.tscn")
var knockback_velocity = Vector2.ZERO

var weapon_settings = {
	"sword": {
		"damage": 15,
		"deal_attack": 0.8
	},
	"spear": {
		"damage": 10,
		"deal_attack": 1.2
	},
	"bow": {
		"damage": 15,
		"deal_attack": 0.8,
		"shot_arrow_delay": 0.7
	}
}

var weapon_sprite_animations = {
	"sword": {
		"side_attack": "side_attack",
		"side_walk": "side_walk",
		"side_idle": "side_idle",
		"front_attack": "front_attack",
		"front_walk": "front_walk",
		"frond_idle": "frond_idle",
		"back_attack": "side_attack",
		"back_walk": "back_walk",
		"back_idle": "back_idle",
		"def": "sword_def"
	},
	"spear": {
		"side_attack": "lancer_side_attack",
		"side_walk": "lancer_run",
		"side_idle": "lancer_idle",
		"front_attack": "lancer_down_attack",
		"front_walk": "lancer_run",
		"frond_idle": "lancer_idle",
		"back_attack": "lancer_up_attack",
		"back_walk": "lancer_run",
		"back_idle": "lancer_idle"
	},
	"bow": {
		"side_attack": "archer_attack",
		"side_walk": "archer_run",
		"side_idle": "archer_idle",
		"front_attack": "archer_attack",
		"front_walk": "archer_run",
		"frond_idle": "archer_idle",
		"back_attack": "archer_attack",
		"back_walk": "archer_run",
		"back_idle": "archer_idle"
	}
}

var weapon_animations_player = {
	"sword": {
		"attack_up": "attack",
		"attack_right": "attack",
		"attack_left": "attack_left",
		"attack_down": "attack"
	},
	"spear": {
		"attack_up": "lancer_up_attack",
		"attack_right": "lancer_right_attack",
		"attack_left": "lancer_left_attack",
		"attack_down": "lancer_down_attack"
	},
	"bow": {
		"attack_up": "archer_attack",
		"attack_right": "archer_attack",
		"attack_left": "archer_attack",
		"attack_down": "archer_attack"
	}
}

var current_weapon = "sword"


func _ready() -> void:
	$AnimatedSprite2D.play("frond_idle")
	$SwordHit/CollisionShape2D.disabled = true


func _physics_process(delta: float) -> void:
	player_movement(delta)
	attack()
	#current_camera()
	
	if Input.is_action_just_pressed("previous_weapon") and not attack_ip and not is_def:
		if current_weapon == "sword":
			current_weapon = "bow"
		elif current_weapon == "spear":
			current_weapon = "sword"
		elif current_weapon == "bow":
			current_weapon = "spear"
			
	if Input.is_action_just_pressed("next_weapon") and not attack_ip and not is_def:
		if current_weapon == "sword":
			current_weapon = "spear"
		elif current_weapon == "spear":
			current_weapon = "bow"
		elif current_weapon == "bow":
			current_weapon = "sword"
			
	if Input.is_action_pressed("right_mouse"):
		if current_weapon == "sword":
			is_def = true
			$AnimatedSprite2D.play(weapon_sprite_animations[current_weapon]["def"])
			
	if Input.is_action_just_released("right_mouse"):
		is_def = false
	
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		move_and_slide()
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)  # Плавное замедление
		return
	
	if global.player_current_health <= 0:
		player_alive = false
		global.player_current_health = 0
		self.queue_free()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	
func player_movement(delta):
	
	if attack_ip or is_def:
		return
	
	var input_vector = Vector2.ZERO
	
	# Собираем ввод с клавиш
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Нормализуем вектор, чтобы диагональное движение не было быстрее
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * global.player_speed
		update_animation_direction(input_vector)
		play_anim(1)  # Анимация движения
	else:
		velocity = Vector2.ZERO
		play_anim(0)  # Анимация покоя
		
	move_and_slide()


func update_animation_direction(input_vector: Vector2):
	# Более точное определение направления с учетом диагоналей
	var angle = input_vector.angle()
	
	if angle >= -PI/4 and angle < PI/4:
		current_dir = "right"
	elif angle >= PI/4 and angle < 3*PI/4:
		current_dir = "down"
	elif angle >= -3*PI/4 and angle < -PI/4:
		current_dir = "up"
	else:
		current_dir = "left"


func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		
		if movement == 1:
			anim.play(weapon_sprite_animations[current_weapon]["side_walk"])
		elif movement == 0:
			if attack_ip == false:
				anim.play(weapon_sprite_animations[current_weapon]["side_idle"])
	elif dir == "left":
		anim.flip_h = true
		
		if movement == 1:
			anim.play(weapon_sprite_animations[current_weapon]["side_walk"])
		elif movement == 0:
			if attack_ip == false:
				anim.play(weapon_sprite_animations[current_weapon]["side_idle"])
	elif dir == "down":
		anim.flip_h = false
		
		if movement == 1:
			anim.play(weapon_sprite_animations[current_weapon]["front_walk"])
		elif movement == 0:
			if attack_ip == false:
				anim.play(weapon_sprite_animations[current_weapon]["frond_idle"])
	elif dir == "up":
		anim.flip_h = false
		
		if movement == 1:
			anim.play(weapon_sprite_animations[current_weapon]["back_walk"])
		elif movement == 0:
			if attack_ip == false:
				anim.play(weapon_sprite_animations[current_weapon]["back_idle"])


func player():
	pass


func apply_knockback(direction: Vector2):
	if direction == Vector2.ZERO:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	knockback_velocity = direction * KNOCKBACK_FORCE


func take_damage(damage, attack_direction: Vector2 = Vector2.ZERO):
	if enemy_attack_cooldown == true:
		global.player_current_health -= damage
		
		if attack_direction != Vector2.ZERO:
			apply_knockback(attack_direction)
		
		healthChanged.emit()
		enemy_attack_cooldown = false
		$TakeDamageTimer.start()
		

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_dir
	
	if is_def:
		return
	
	if Input.is_action_just_pressed("left_mouse") and not attack_ip:
		global.player_current_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play(weapon_sprite_animations[current_weapon]["side_attack"])
			$AnimationPlayer.play(weapon_animations_player[current_weapon]["attack_right"])
			$DealAttackTimer.start(weapon_settings[current_weapon]["deal_attack"])
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play(weapon_sprite_animations[current_weapon]["side_attack"])
			$AnimationPlayer.play(weapon_animations_player[current_weapon]["attack_left"])
			$DealAttackTimer.start(weapon_settings[current_weapon]["deal_attack"])
		elif dir == "down":
			$AnimatedSprite2D.play(weapon_sprite_animations[current_weapon]["front_attack"])
			$AnimationPlayer.play(weapon_animations_player[current_weapon]["attack_down"])
			$DealAttackTimer.start(weapon_settings[current_weapon]["deal_attack"])
		elif dir == "up":
			$AnimatedSprite2D.play(weapon_sprite_animations[current_weapon]["back_attack"])
			$AnimationPlayer.play(weapon_animations_player[current_weapon]["attack_up"])
			$DealAttackTimer.start(weapon_settings[current_weapon]["deal_attack"])

		if current_weapon == "bow":
			await get_tree().create_timer(weapon_settings["bow"]["shot_arrow_delay"]).timeout
			var arrow_instance = arrow.instantiate()
			arrow_instance.rotation = $Marker2D.rotation
			arrow_instance.global_position = $Marker2D.global_position
			arrow_instance.global_position.y = $Marker2D.global_position.y - 20
			$"..".add_child(arrow_instance)

func _on_deal_attack_timer_timeout() -> void:
	$DealAttackTimer.stop()
	attack_ip = false


#func current_camera():
	#if global.current_scene == "world":
		#$WorldCamera.enabled = true
		#$CliffsideCamera.enabled = false
		#
	#elif global.current_scene == "cliff_side":
		#$WorldCamera.enabled = false
		#$CliffsideCamera.enabled = true



func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("enemy"):
		var enemy_position = area.get_parent().global_position
		var player_position = global_position
		var attack_direction = (enemy_position - player_position).normalized()
		
		area.get_parent().take_damage(weapon_settings[current_weapon]["damage"] + global.current_attack_mult, attack_direction)


func _on_sword_hit_body_entered(body: Node2D) -> void:
	if body.get_parent().has_method("destructible"):
		body.get_parent().destroy()
