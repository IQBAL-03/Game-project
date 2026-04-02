extends CharacterBody2D

const kecepatan_jalan = 150.0
const kecepatan_lari = 250.0 
const kekuatan_loncat = -350.0
const kecepatan_climb = 100.0

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
var is_climbing = false
var can_climb = false
var nearest_ladder_center = Vector2.INF

@onready var sprite = $AnimatedSprite2D
@onready var attack_box: Area2D = $AttackBox
@onready var climb_sprite: AnimatedSprite2D = $climb
@onready var tilemap: TileMapLayer = get_parent().get_node("objek")
@onready var collision_shape: CollisionShape2D = $Badan

func _ready():
	floor_max_angle = deg_to_rad(60)
	floor_snap_length = 8.0
	sprite.animation_finished.connect(_on_animation_finished)
	
	if attack_box:
		attack_box.monitoring = false
		attack_box.monitorable = false
	
	if climb_sprite:
		climb_sprite.position = Vector2(61, 83)
		climb_sprite.visible = false

func _physics_process(_delta):
	if timer_lari > 0:
		timer_lari -= _delta
	
	check_climbable_tile()
	
	if is_climbing:
		handle_climbing(_delta)
		return
	
	if not is_on_floor():
		velocity.y += gravitasi * _delta
	else:
		bisa_double_jump = true

	var mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if mouse_pressed and not mouse_was_pressed and not sedang_serang and is_on_floor():
		serang()
	mouse_was_pressed = mouse_pressed

	if Input.is_action_just_pressed("ui_accept") and not sedang_serang:
		if is_on_floor():
			velocity.y = kekuatan_loncat
		elif bisa_double_jump:
			velocity.y = kekuatan_loncat
			bisa_double_jump = false
	
	if Input.is_action_just_pressed("ui_up") and can_climb and not sedang_serang:
		start_climbing()
		return

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
	
	if attack_box:
		attack_box.monitoring = true
		attack_box.monitorable = true

func _on_animation_finished():
	if sprite.animation == "serang":
		sedang_serang = false
		
		if attack_box:
			attack_box.monitoring = false
			attack_box.monitorable = false

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


func check_climbable_tile() -> void:
	if tilemap == null:
		can_climb = false
		return
	
	can_climb = false
	nearest_ladder_center = Vector2.INF
	var min_dist = INF
	
	for x_off in range(-8, 9, 8):
		for y_off in range(-16, 17, 8):
			var check_pos = collision_shape.global_position + Vector2(x_off, y_off)
			var tile_pos = tilemap.local_to_map(tilemap.to_local(check_pos))
			var tile_data = tilemap.get_cell_tile_data(tile_pos)
			if tile_data and tile_data.get_custom_data("climbable"):
				var tile_center = tilemap.to_global(tilemap.map_to_local(tile_pos))
				var dist = abs(collision_shape.global_position.x - tile_center.x)
				if dist < min_dist:
					min_dist = dist
					nearest_ladder_center = tile_center
					can_climb = true


func start_climbing() -> void:
	is_climbing = true
	velocity = Vector2.ZERO
	
	var ladder_to_right = false
	var ladder_to_left = false
	
	if nearest_ladder_center != Vector2.INF:
		var x_diff = nearest_ladder_center.x - collision_shape.global_position.x
		if x_diff > 2:
			ladder_to_right = true
		elif x_diff < -2:
			ladder_to_left = true
	
	sprite.visible = false
	if climb_sprite:
		climb_sprite.visible = true
		climb_sprite.play("climb")
		
		if ladder_to_right:
			climb_sprite.flip_h = false
		elif ladder_to_left:
			climb_sprite.flip_h = true
		else:
			climb_sprite.flip_h = sprite.flip_h


func handle_climbing(_delta: float) -> void:
	var vertical_input = Input.get_axis("ui_up", "ui_down")
	
	if vertical_input != 0:
		velocity.y = vertical_input * kecepatan_climb
		if climb_sprite:
			climb_sprite.play()
	else:
		velocity.y = 0
		if climb_sprite:
			climb_sprite.pause()
	
	velocity.x = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		stop_climbing()
		velocity.y = kekuatan_loncat
		return
	
	if not can_climb:
		stop_climbing()
		return
	
	move_and_slide()


func stop_climbing() -> void:
	is_climbing = false
	
	sprite.visible = true
	if climb_sprite:
		sprite.flip_h = climb_sprite.flip_h
		climb_sprite.visible = false
