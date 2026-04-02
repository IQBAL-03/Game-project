extends CharacterBody2D

@export var attack_speed: float = 1.0
@export var flip_offset: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var reaksi: Area2D = $Reaksi # Node Reaksi buatan abang

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false

var original_sprite_pos_x: float = 0.0
var sprite_local_center: Vector2 = Vector2.ZERO

# Variabel pembaca posisi Kanan/Kiri dari CollisionShape2D
var player_di_kanan: bool = false
var player_di_kiri: bool = false

func _ready() -> void:
	original_sprite_pos_x = animated_sprite.position.x
	sprite_local_center = animated_sprite.position

	animated_sprite.play("idle")

	hitbox.area_entered.connect(_on_hitbox_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	# Sambungkan signal pembaca part kotak (shape)
	if reaksi:
		reaksi.body_shape_entered.connect(_on_reaksi_body_shape_entered)
		reaksi.body_shape_exited.connect(_on_reaksi_body_shape_exited)
	else:
		push_error("Node Reaksi belum ada!")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	# Kalau player terdeteksi masuk ke dalem salah satu kotak (Kanan atau Kiri)
	if player_di_kanan or player_di_kiri:
		if not is_attacking:
			is_attacking = true

		# Tentukan hadapnya, karena plant ke 1 cuman main serang_kiri dan di flip
		if player_di_kanan:
			animated_sprite.flip_h = true
			animated_sprite.position.x = original_sprite_pos_x + flip_offset
		else:
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x

		if animated_sprite.animation != "serang_kiri":
			animated_sprite.play("serang_kiri")
			animated_sprite.speed_scale = attack_speed
	else:
		# Kalau player keluar
		if is_attacking:
			animated_sprite.play("idle")
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			is_attacking = false

# Fungsi saat Player masuk ke kotak Kanan/Kiri
func _on_reaksi_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player = body
		# Ngecek dia nabrak kotak (CollisionShape2D) yang mana
		var owner_id = reaksi.shape_find_owner(local_shape_index)
		var kotak_masuk = reaksi.shape_owner_get_owner(owner_id)
		
		if kotak_masuk.name == "Kanan":
			player_di_kanan = true
		elif kotak_masuk.name == "Kiri":
			player_di_kiri = true

# Fungsi saat Player keluar dari kotak Kanan/Kiri
func _on_reaksi_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and body == player:
		# Ngecek dia keluar dari kotak mana
		var owner_id = reaksi.shape_find_owner(local_shape_index)
		var kotak_keluar = reaksi.shape_owner_get_owner(owner_id)
		
		if kotak_keluar.name == "Kanan":
			player_di_kanan = false
		elif kotak_keluar.name == "Kiri":
			player_di_kiri = false

func _on_animation_finished() -> void:
	if animated_sprite.animation == "serang_kiri":
		# Selama player masih dalam kotak, lanjut serang terus
		if is_attacking and (player_di_kanan or player_di_kiri):
			animated_sprite.play("serang_kiri")
		else:
			animated_sprite.play("idle")
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			is_attacking = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		is_attacking = false
		
		# Langsung matikan collision agar player bisa tembus
		$CollisionShape2D.set_deferred("disabled", true)

		# Logika mutlak ide abang pakai kotak area Kanan dan Kiri
		if player_di_kanan:
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			animated_sprite.play("mati_kiri")

		await animated_sprite.animation_finished
		queue_free()
