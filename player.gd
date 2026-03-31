extends CharacterBody2D

const kecepatan_jalan = 150.0
const kecepatan_lari = 250.0 
const kekuatan_loncat = -350.0

var kecepatan_skrg = kecepatan_jalan
var bisa_double_jump = false
var gravitasi = ProjectSettings.get_setting("physics/2d/default_gravity")

var carried_keys = []
var bawa_kunci = false
var has_key = false

var timer_lari = 0.0
const WAKTU_DOUBLE_TAP = 0.25 
var sedang_lari = false
var tombol_terakhir = ""
var sedang_serang = false
var mouse_was_pressed = false

@onready var sprite = $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox

func _ready():
	floor_max_angle = deg_to_rad(60)
	floor_snap_length = 8.0
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Nonaktifkan AttackBox di awal
	if attack_box:
		attack_box.monitoring = false
		attack_box.monitorable = false

func _physics_process(delta):
	if timer_lari > 0:
		timer_lari -= delta

	if not is_on_floor():
		velocity.y += gravitasi * delta
	else:
		bisa_double_jump = true

	# Serang dengan klik kiri (hanya sekali per klik)
	var mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if mouse_pressed and not mouse_was_pressed and not sedang_serang and is_on_floor():
		serang()
	mouse_was_pressed = mouse_pressed

	if Input.is_action_just_pressed("ui_up") and not sedang_serang:
		if is_on_floor():
			velocity.y = kekuatan_loncat
		elif bisa_double_jump:
			velocity.y = kekuatan_loncat
			bisa_double_jump = false

	var arah = Input.get_axis("ui_left", "ui_right")
	
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")) and not sedang_serang:
		var tombol_skrg = "kiri" if Input.is_action_just_pressed("ui_left") else "kanan"
		if timer_lari > 0 and tombol_terakhir == tombol_skrg:
			sedang_lari = true
		else:
			timer_lari = WAKTU_DOUBLE_TAP
			sedang_lari = false
		tombol_terakhir = tombol_skrg

	if arah == 0:
		sedang_lari = false

	kecepatan_skrg = kecepatan_lari if sedang_lari else kecepatan_jalan
	
	if sedang_serang and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, kecepatan_jalan)
	elif arah != 0:
		velocity.x = arah * kecepatan_skrg
		sprite.flip_h = (arah < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, kecepatan_jalan)

	update_animations(arah)
	move_and_slide()

func serang():
	sedang_serang = true
	sprite.play("serang")
	print("Serang dimulai!")
	
	# Aktifkan AttackBox saat serang
	if attack_box:
		attack_box.monitoring = true
		attack_box.monitorable = true
		print("AttackBox AKTIF")

func _on_animation_finished():
	if sprite.animation == "serang":
		sedang_serang = false
		print("Serang selesai!")
		
		# Nonaktifkan AttackBox setelah serang selesai
		if attack_box:
			attack_box.monitoring = false
			attack_box.monitorable = false
			print("AttackBox NONAKTIF")

func update_animations(arah):
	if sedang_serang:
		return

	if not is_on_floor():
		if sprite.animation != "lompat":
			sprite.play("lompat")
	elif arah != 0:
		if sedang_lari:
			if sprite.animation != "lari": 
				sprite.play("lari")
		else:
			if sprite.animation != "jalan":
				sprite.play("jalan")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
