extends CharacterBody2D

@export var attack_speed: float = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitBox
@onready var reaksi: Area2D = get_node_or_null("Reaksi")

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false

# Variabel baru nampung kotak mana yang diinjek player
var player_di_kanan: bool = false
var player_di_kiri: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	
	if reaksi:
		reaksi.body_shape_entered.connect(_on_reaksi_body_shape_entered)
		reaksi.body_shape_exited.connect(_on_reaksi_body_shape_exited)
	else:
		push_error("PREDATOR_PLANT_2: Node 'Reaksi' belum ada! Bikin dulu ya bang Area2D dan Collisionnya.")

func _physics_process(delta: float) -> void:
	if is_dead: return

	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	# Kalau player terdeteksi masuk kotak Kanan atau Kiri
	if player_di_kanan or player_di_kiri:
		if not is_attacking:
			is_attacking = true

		animated_sprite.speed_scale = attack_speed
		
		# Pilih animasi sesuai kotak mana yang diinjek
		var target_anim = "serang_kanan" if player_di_kanan else "serang_kiri"

		if animated_sprite.animation != target_anim:
			animated_sprite.play(target_anim)
	else:
		if is_attacking:
			is_attacking = false
			animated_sprite.play("idle")

# Fungsi saat masuk ke area shape spesifik
func _on_reaksi_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player = body
		var owner_id = reaksi.shape_find_owner(local_shape_index)
		var kotak_masuk = reaksi.shape_owner_get_owner(owner_id)
		
		if kotak_masuk.name == "Kanan":
			player_di_kanan = true
		elif kotak_masuk.name == "Kiri":
			player_di_kiri = true

# Fungsi saat keluar area shape spesifik
func _on_reaksi_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and body == player:
		var owner_id = reaksi.shape_find_owner(local_shape_index)
		var kotak_keluar = reaksi.shape_owner_get_owner(owner_id)
		
		if kotak_keluar.name == "Kanan":
			player_di_kanan = false
		elif kotak_keluar.name == "Kiri":
			player_di_kiri = false

func _on_animation_finished() -> void:
	var anim = animated_sprite.animation
	if anim == "serang_kanan" or anim == "serang_kiri":
		# Selama masi ada di dalam kotak, loop serang terus
		if is_attacking and (player_di_kanan or player_di_kiri):
			var target_anim = "serang_kanan" if player_di_kanan else "serang_kiri"
			animated_sprite.play(target_anim)
		else:
			animated_sprite.play("idle")
			is_attacking = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		is_attacking = false
		
		# Langsung matikan collision agar player bisa tembus
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Logika mutlak ide abang pakai kotak area Kanan dan Kiri
		if player_di_kanan:
			animated_sprite.play("mati_kanan")
		else:
			animated_sprite.play("mati_kiri")
			
		await animated_sprite.animation_finished
		queue_free()

func set_animation_speed(speed: float) -> void:
	if speed <= 0: return
	attack_speed = speed
	if is_attacking: animated_sprite.speed_scale = speed
