extends CharacterBody2D

@export var radius_kanan: float = 150.0
@export var radius_kiri: float = 150.0
@export var radius_y: float = 200.0
@export var attack_speed: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	if is_dead: return

	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0: player = players[0]
		else: return

	if not is_instance_valid(player):
		player = null
		return

	# Titik pusat visual pake sprite
	var center_pos = animated_sprite.global_position
	var dir_x = player.global_position.x - center_pos.x
	var dir_y = abs(player.global_position.y - center_pos.y)
	
	# Cek area deteksi (X dan Y)
	var dalam_area = false
	if dir_y <= radius_y: # Cek jarak tinggi dulu
		if dir_x > 0:
			if dir_x <= radius_kanan: dalam_area = true
		else:
			if abs(dir_x) <= radius_kiri: dalam_area = true

	if dalam_area:
		is_attacking = true
		animated_sprite.speed_scale = attack_speed

		# Tentukan animasi
		var target_anim = "serang_kanan" if dir_x > 0 else "serang_kiri"

		if animated_sprite.animation != target_anim:
			animated_sprite.play(target_anim)
	else:
		if is_attacking:
			is_attacking = false
			animated_sprite.play("idle")

func _on_animation_finished() -> void:
	var anim = animated_sprite.animation
	if anim == "serang_kanan" or anim == "serang_kiri":
		if is_attacking and player and is_instance_valid(player):
			var center_pos = animated_sprite.global_position
			var dir_x = player.global_position.x - center_pos.x
			var dir_y = abs(player.global_position.y - center_pos.y)
			
			var masih_dalam_area = false
			if dir_y <= radius_y:
				if dir_x > 0:
					if dir_x <= radius_kanan: masih_dalam_area = true
				else:
					if abs(dir_x) <= radius_kiri: masih_dalam_area = true
			
			if masih_dalam_area:
				var target_anim = "serang_kanan" if dir_x > 0 else "serang_kiri"
				animated_sprite.play(target_anim)
			else:
				animated_sprite.play("idle")
				is_attacking = false
		else:
			animated_sprite.play("idle")
			is_attacking = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		is_attacking = false
		var center_pos = animated_sprite.global_position
		var dir_x = player.global_position.x - center_pos.x if player and is_instance_valid(player) else 0.0
		if dir_x > 0:
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.play("mati_kiri")
		await animated_sprite.animation_finished
		queue_free()

func set_detection_radius(radius: float) -> void:
	radius_kanan = radius
	radius_kiri = radius

func set_animation_speed(speed: float) -> void:
	if speed <= 0: return
	attack_speed = speed
	if is_attacking: animated_sprite.speed_scale = speed
