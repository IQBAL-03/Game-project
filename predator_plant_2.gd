extends CharacterBody2D

@export var detection_radius: float = 10.0
@export var attack_speed: float = 1.0
@export var flip_offset: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false
var original_sprite_pos_x: float = 0.0
var sprite_local_center: Vector2 = Vector2.ZERO


func _ready() -> void:
	original_sprite_pos_x = animated_sprite.position.x
	sprite_local_center = animated_sprite.position

	animated_sprite.play("idle")

	hitbox.area_entered.connect(_on_hitbox_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	if is_dead:
		return

	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			return

	if not is_instance_valid(player):
		player = null
		return

	var sprite_global = to_global(sprite_local_center)
	var dir_x = player.global_position.x - sprite_global.x

	if abs(dir_x) <= detection_radius:
		if not is_attacking:
			is_attacking = true
			_play_attack_anim(dir_x)
			animated_sprite.speed_scale = attack_speed
	else:
		if is_attacking:
			animated_sprite.play("idle")
			is_attacking = false


func _play_attack_anim(dir_x: float) -> void:
	if dir_x > 0:
		animated_sprite.play("serang_kanan")
	else:
		animated_sprite.play("serang_kiri")


func _on_animation_finished() -> void:
	var anim = animated_sprite.animation
	if anim == "serang_kanan" or anim == "serang_kiri":
		if is_attacking and player and is_instance_valid(player):
			var sprite_global = to_global(sprite_local_center)
			var dir_x = player.global_position.x - sprite_global.x
			if abs(dir_x) <= detection_radius:
				_play_attack_anim(dir_x)
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

		var sprite_global = to_global(sprite_local_center)
		if player and is_instance_valid(player) and player.global_position.x > sprite_global.x:
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.play("mati_kiri")

		await animated_sprite.animation_finished
		queue_free()


func set_detection_radius(radius: float) -> void:
	if radius <= 0:
		push_warning("Detection radius must be positive, got: ", radius)
		return
	detection_radius = radius


func set_animation_speed(speed: float) -> void:
	if speed <= 0:
		push_warning("Animation speed must be positive, got: ", speed)
		return
	attack_speed = speed
	if is_attacking:
		animated_sprite.speed_scale = speed
