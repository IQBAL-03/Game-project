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

var is_dead = false
var is_teleporting = false
var spawn_position: Vector2
var last_safe_position: Vector2
var coins = 0


var timer_lari = 0.0

const WAKTU_DOUBLE_TAP = 0.25

var sedang_lari = false

var tombol_terakhir = ""

var sedang_serang = false

var is_hit_invulnerable = false

var mouse_was_pressed = false

var is_climbing = false

var can_climb = false

var nearest_ladder_center = Vector2.INF


@onready var sprite = $AnimatedSprite2D

@onready var attack_box: Area2D = $AttackBox

@onready var climb_sprite: AnimatedSprite2D = $climb

@onready var tilemap: TileMapLayer = get_parent().get_node("objek")

@onready var duri_tilemap: TileMapLayer = get_parent().get_node("duri")

@onready var collision_shape: CollisionShape2D = $Badan

@onready var health_component: Node = $HealthComponent
var original_sprite_x = 0.0
var original_attack_x = 0.0
var original_hurt_x = 0.0
var original_badan_x = 0.0

@onready var hurt_box = get_node_or_null("HurtBox")

func _ready():
	spawn_position = global_position
	last_safe_position = global_position
	add_to_group("player")

	floor_max_angle = deg_to_rad(60)

	floor_snap_length = 8.0

	sprite.animation_finished.connect(_on_animation_finished)

	if sprite:
		original_sprite_x = sprite.position.x
	if collision_shape:
		original_badan_x = collision_shape.position.x
	if attack_box and attack_box.has_node("CollisionShape2D"):
		original_attack_x = attack_box.get_node("CollisionShape2D").position.x
	if hurt_box and hurt_box.has_node("CollisionShape2D"):
		original_hurt_x = hurt_box.get_node("CollisionShape2D").position.x


	if attack_box:

		attack_box.monitoring = false

		attack_box.monitorable = false


	if climb_sprite:

		climb_sprite.position = Vector2(61, 83)

		climb_sprite.visible = false


	if health_component:

		health_component.health_changed.connect(_on_health_changed)

		health_component.died.connect(_on_health_died)


func _physics_process(_delta):
	if is_teleporting:
		velocity = Vector2.ZERO
		return

	if is_dead:

		velocity.x = 0

		if is_on_floor():

			velocity.y = 0

		else:

			velocity.y += gravitasi * _delta

		move_and_slide()

		return


	if timer_lari > 0:

		timer_lari -= _delta


	check_climbable_tile()

	check_duri_tile()

	if is_dead:

		return


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

		if arah < 0:
			if sprite and collision_shape:
				sprite.position.x = original_badan_x - (original_sprite_x - original_badan_x)
			if attack_box and attack_box.has_node("CollisionShape2D") and collision_shape:
				attack_box.get_node("CollisionShape2D").position.x = original_badan_x - (original_attack_x - original_badan_x)
			if hurt_box and hurt_box.has_node("CollisionShape2D") and collision_shape:
				hurt_box.get_node("CollisionShape2D").position.x = original_badan_x - (original_hurt_x - original_badan_x)
		else:
			if sprite:
				sprite.position.x = original_sprite_x
			if attack_box and attack_box.has_node("CollisionShape2D"):
				attack_box.get_node("CollisionShape2D").position.x = original_attack_x
			if hurt_box and hurt_box.has_node("CollisionShape2D"):
				hurt_box.get_node("CollisionShape2D").position.x = original_hurt_x

	else:

		velocity.x = move_toward(velocity.x, 0, kecepatan_jalan)


	update_animations(arah)

	move_and_slide()


	if is_on_floor() and not is_dead and not is_teleporting and not is_on_spikes():
		last_safe_position = global_position


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


func check_duri_tile() -> void:
	if is_dead or duri_tilemap == null:
		return

	if is_on_spikes():
		_on_spike_hit()

func is_on_spikes() -> bool:
	if duri_tilemap == null or collision_shape == null or collision_shape.shape == null:
		return false

	var shape = collision_shape.shape as RectangleShape2D
	if not shape:
		return false

	var half_extents = shape.size * 0.5
	var global_pos = collision_shape.global_position

	var top_left_local = duri_tilemap.to_local(global_pos - half_extents)
	var bottom_right_local = duri_tilemap.to_local(global_pos + half_extents)

	var map_min = duri_tilemap.local_to_map(top_left_local)
	var map_max = duri_tilemap.local_to_map(bottom_right_local)

	var start_x = min(map_min.x, map_max.x)
	var end_x = max(map_min.x, map_max.x)
	var start_y = min(map_min.y, map_max.y)
	var end_y = max(map_min.y, map_max.y)

	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_pos = Vector2i(x, y)
			var tile_data = duri_tilemap.get_cell_tile_data(tile_pos)
			if tile_data != null:
				return true
	return false


func check_climbable_tile() -> void:
	if tilemap == null or collision_shape == null or collision_shape.shape == null:
		can_climb = false
		return

	var shape = collision_shape.shape as RectangleShape2D
	if not shape:
		can_climb = false
		return

	can_climb = false
	nearest_ladder_center = Vector2.INF
	var min_dist = INF

	var half_extents = shape.size * 0.5
	var global_pos = collision_shape.global_position

	var top_left_local = tilemap.to_local(global_pos - half_extents)
	var bottom_right_local = tilemap.to_local(global_pos + half_extents)

	var map_min = tilemap.local_to_map(top_left_local)
	var map_max = tilemap.local_to_map(bottom_right_local)

	var start_x = min(map_min.x, map_max.x)
	var end_x = max(map_min.x, map_max.x)
	var start_y = min(map_min.y, map_max.y)
	var end_y = max(map_min.y, map_max.y)

	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_pos = Vector2i(x, y)
			var tile_data = tilemap.get_cell_tile_data(tile_pos)
			if tile_data and tile_data.get_custom_data("climbable"):
				var tile_center = tilemap.to_global(tilemap.map_to_local(tile_pos))
				var dist = abs(global_pos.x - tile_center.x)
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

			if collision_shape:
				climb_sprite.position.x = 61

		elif ladder_to_left:

			climb_sprite.flip_h = true

			if collision_shape:
				climb_sprite.position.x = original_badan_x - (61 - original_badan_x)

		else:

			climb_sprite.flip_h = sprite.flip_h

			if collision_shape:
				if sprite.flip_h:
					climb_sprite.position.x = original_badan_x - (61 - original_badan_x)
				else:
					climb_sprite.position.x = 61


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
		
		if sprite.flip_h:
			if sprite:
				sprite.position.x = original_badan_x - (original_sprite_x - original_badan_x)
			if attack_box and attack_box.has_node("CollisionShape2D"):
				attack_box.get_node("CollisionShape2D").position.x = original_badan_x - (original_attack_x - original_badan_x)
			if hurt_box and hurt_box.has_node("CollisionShape2D"):
				hurt_box.get_node("CollisionShape2D").position.x = original_badan_x - (original_hurt_x - original_badan_x)
		else:
			if sprite:
				sprite.position.x = original_sprite_x
			if attack_box and attack_box.has_node("CollisionShape2D"):
				attack_box.get_node("CollisionShape2D").position.x = original_attack_x
			if hurt_box and hurt_box.has_node("CollisionShape2D"):
				hurt_box.get_node("CollisionShape2D").position.x = original_hurt_x


var prev_health = -1


func is_evading() -> bool:

	return not is_on_floor() or sedang_lari or is_hit_invulnerable


func _on_health_changed(_current: int, _maximum: int) -> void:

	if prev_health == -1:

		prev_health = _maximum


	if not is_dead and _current < prev_health:

		start_flashing()

	prev_health = _current


func start_flashing() -> void:

	if is_hit_invulnerable:

		return

	is_hit_invulnerable = true

	var tween = create_tween()

	tween.set_loops(5)

	tween.tween_property(sprite, "modulate", Color(1, 0, 0, 1), 0.1)

	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1)

	await tween.finished

	is_hit_invulnerable = false

	sprite.modulate = Color(1, 1, 1, 1)


func _on_health_died() -> void:

	is_dead = true

	is_hit_invulnerable = false

	sprite.modulate = Color(1, 1, 1, 1)

	sedang_serang = false


	if is_climbing:

		is_climbing = false

		if climb_sprite:

			climb_sprite.visible = false

		sprite.visible = true


	if sprite.sprite_frames.has_animation("mati"):

		sprite.play("mati")

	elif sprite.sprite_frames.has_animation("death"):

		sprite.play("death") 


	if not is_dead:
		sprite.play("idle")

func _on_spike_hit() -> void:
	if is_teleporting or is_dead:
		return


	if health_component and health_component.get_current_health() <= 1:
		if health_component:
			health_component.take_damage(1, true)
		return

	is_teleporting = true


	if sprite.sprite_frames.has_animation("mati"):
		sprite.play("mati")
	elif sprite.sprite_frames.has_animation("death"):
		sprite.play("death")


	var fade_layer = CanvasLayer.new()
	fade_layer.layer = 100
	add_child(fade_layer)

	var fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 0)
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_layer.add_child(fade_rect)

	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 0.5)
	await tween.finished


	var nudge_x = 25 if sprite.flip_h else -25
	global_position = last_safe_position + Vector2(nudge_x, -5)
	velocity = Vector2.ZERO


	if health_component:
		health_component.take_damage(1, true)


	await get_tree().create_timer(0.3).timeout


	var tween_out = create_tween()
	tween_out.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.5)
	await tween_out.finished

	fade_layer.queue_free()
	is_teleporting = false


	if not is_dead:
		sprite.play("idle")

func collect_coin(amount: int = 1) -> void:
	coins += amount
	var hud_nodes = get_tree().get_nodes_in_group("hud")
	if hud_nodes.size() > 0:
		hud_nodes[0].update_coins(coins)