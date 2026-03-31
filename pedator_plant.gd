extends CharacterBody2D

# Configuration
@export var detection_radius: float = 150.0
@export var attack_speed: float = 1.0

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

# State
var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false


func _ready() -> void:
	# Setup animation
	animated_sprite.play("idle")
	
	# Connect Hitbox signal
	hitbox.area_entered.connect(_on_hitbox_area_entered)


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
	
	# Debug print
	if distance <= detection_radius:
		print("Player detected! Distance: ", distance, " Animation: ", animated_sprite.animation)
	
	if distance <= detection_radius:
		# Determine attack direction based on player position
		var target_animation = ""
		
		if player.global_position.x > global_position.x:
			# Player is on the right
			target_animation = "serang_kanan"
		else:
			# Player is on the left
			target_animation = "serang_kiri"
		
		# Play animation if different or not playing
		if animated_sprite.animation != target_animation or not animated_sprite.is_playing():
			animated_sprite.play(target_animation)
			is_attacking = true
	else:
		# Player out of range, return to idle
		if is_attacking or animated_sprite.animation != "idle":
			animated_sprite.play("idle")
			is_attacking = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	# Check if it's player's attack
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		
		# Determine death animation based on player position
		if player and player.global_position.x > global_position.x:
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.play("mati_kiri")
		
		# Wait for animation to finish, then disable
		await animated_sprite.animation_finished
		queue_free()  # Remove from scene
