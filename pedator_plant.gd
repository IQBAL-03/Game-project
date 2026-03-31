extends CharacterBody2D

# Configuration
@export var detection_radius: float = 150.0
@export var attack_speed: float = 1.0
@export var flip_offset: float = 0.0

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

# State
var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false
var original_sprite_pos_x: float = 0.0


func _ready() -> void:
	# Save original sprite position
	original_sprite_pos_x = animated_sprite.position.x
	
	# Setup animation
	animated_sprite.play("idle")
	
	# Connect Hitbox signal
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	
	# Connect animation finished signal
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
	
	# Skip detection if dead
	if is_dead:
		return
	
	# Find player
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			return
	
	# Check if player is valid
	if not is_instance_valid(player):
		player = null
		return
	
	# Check if player is in detection range
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= detection_radius:
		# Player detected - start attacking
		if not is_attacking:
			is_attacking = true
		
		# Determine direction and flip sprite
		var dir_x = player.global_position.x - global_position.x
		
		if abs(dir_x) > 2.0:
			if dir_x > 0:
				# Player is on the right
				animated_sprite.flip_h = true
				animated_sprite.position.x = original_sprite_pos_x + flip_offset
			else:
				# Player is on the left
				animated_sprite.flip_h = false
				animated_sprite.position.x = original_sprite_pos_x
		
		# Play attack animation
		if animated_sprite.animation != "serang_kanan":
			animated_sprite.play("serang_kanan")
			animated_sprite.speed_scale = attack_speed
	else:
		# Player out of range, return to idle
		if is_attacking:
			animated_sprite.play("idle")
			is_attacking = false


func _on_animation_finished() -> void:
	# Jika animasi serang selesai, kembali ke idle
	if animated_sprite.animation == "serang_kanan":
		# Cek apakah player masih dalam range
		if is_attacking and player and is_instance_valid(player):
			var distance = global_position.distance_to(player.global_position)
			if distance <= detection_radius:
				# Player masih dalam range, serang lagi
				animated_sprite.play("serang_kanan")
			else:
				# Player keluar range, kembali ke idle
				animated_sprite.play("idle")
				is_attacking = false
		else:
			# Tidak ada player, kembali ke idle
			animated_sprite.play("idle")
			is_attacking = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	# Check if it's player's attack
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		
		# Stop attacking
		is_attacking = false
		
		# Determine death animation based on player position
		if player and player.global_position.x > global_position.x:
			animated_sprite.flip_h = true
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.flip_h = false
			animated_sprite.play("mati_kiri")
		
		# Wait for animation to finish, then remove
		await animated_sprite.animation_finished
		queue_free()
