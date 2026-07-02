extends CharacterBody2D

@export var attack_speed: float = 1.0
@export var damage_amount: float = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = get_node_or_null("Hitbox")
@onready var reaksi: Area2D = get_node_or_null("Reaksi")
@onready var attack_box: Area2D = null

var health_component: Node = null
var health_bar_sprite: Sprite2D = null
var bar_full_tex: Texture2D = null
var bar_half_tex: Texture2D = null
var bar_empty_tex: Texture2D = null

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false
var attack_box_active: bool = false
const MAX_HEALTH: int = 2
var is_flashing: bool = false

var player_di_kanan: bool = false
var player_di_kiri: bool = false

func _ready() -> void:
	health_component = preload("res://scripts/Core/health_component.gd").new()
	health_component.name = "HealthComponent"
	health_component.max_health = MAX_HEALTH
	add_child(health_component)

	bar_full_tex = _create_bar_texture(Color(0.8, 0.1, 0.1), Color(0.8, 0.1, 0.1))
	bar_half_tex = _create_bar_texture(Color(0.8, 0.1, 0.1), Color(0.25, 0.25, 0.25))
	bar_empty_tex = _create_bar_texture(Color(0.25, 0.25, 0.25), Color(0.25, 0.25, 0.25))

	health_bar_sprite = Sprite2D.new()
	health_bar_sprite.texture = bar_full_tex
	health_bar_sprite.visible = false
	health_bar_sprite.position = animated_sprite.position + Vector2(0, -60)
	add_child(health_bar_sprite)

	health_component.health_changed.connect(_on_enemy_health_changed)
	health_component.died.connect(_on_died)

	animated_sprite.play("idle")
	if hitbox:
		hitbox.area_entered.connect(_on_hitbox_area_entered)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.frame_changed.connect(_on_sprite_frame_changed)

	attack_box = Area2D.new()
	attack_box.name = "AttackBox"
	attack_box.monitoring = false
	attack_box.monitorable = false
	add_child(attack_box)

	var attack_collision = CollisionShape2D.new()
	var attack_shape = RectangleShape2D.new()
	attack_shape.size = Vector2(67, 71)
	attack_collision.shape = attack_shape
	attack_collision.position = Vector2(30, 0)
	attack_box.add_child(attack_collision)

	attack_box.area_entered.connect(_on_attack_box_area_entered)

	if reaksi:
		reaksi.body_shape_entered.connect(_on_reaksi_body_shape_entered)
		reaksi.body_shape_exited.connect(_on_reaksi_body_shape_exited)

func _physics_process(delta: float) -> void:
	if is_dead: return

	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	if player_di_kanan or player_di_kiri:
		if not is_attacking:
			is_attacking = true

		animated_sprite.speed_scale = attack_speed

		var target_anim = "serang_kanan" if player_di_kanan else "serang_kiri"

		if attack_box and attack_box.get_child_count() > 0:
			var attack_collision = attack_box.get_child(0)
			if attack_collision:
				attack_collision.position = Vector2(30, 0) if player_di_kanan else Vector2(-30, 0)

		if animated_sprite.animation != target_anim:
			animated_sprite.play(target_anim)
	else:
		if is_attacking:
			is_attacking = false
			animated_sprite.play("idle")

			if attack_box:
				attack_box.set_deferred("monitoring", false)
				attack_box_active = false

func _on_reaksi_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player = body
		var owner_id = reaksi.shape_find_owner(local_shape_index)
		var kotak_masuk = reaksi.shape_owner_get_owner(owner_id)

		if kotak_masuk.name == "Kanan":
			player_di_kanan = true
		elif kotak_masuk.name == "Kiri":
			player_di_kiri = true

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
		if attack_box:
			attack_box.set_deferred("monitoring", false)
			attack_box_active = false

		if is_attacking and (player_di_kanan or player_di_kiri):
			var target_anim = "serang_kanan" if player_di_kanan else "serang_kiri"
			animated_sprite.play(target_anim)
		else:
			animated_sprite.play("idle")
			is_attacking = false

func _on_sprite_frame_changed() -> void:
	var anim = animated_sprite.animation
	if (anim == "serang_kanan" or anim == "serang_kiri") and is_attacking:
		if animated_sprite.frame == 5:
			if attack_box:
				attack_box.set_deferred("monitoring", true)
				attack_box_active = true
		elif animated_sprite.frame != 5:
			if attack_box and attack_box_active:
				attack_box.set_deferred("monitoring", false)
				attack_box_active = false

func _on_attack_box_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox" and attack_box_active and not is_dead:
		var player_node = area.get_parent()
		if player_node and player_node.is_in_group("player"):
			var actual_damage = damage_amount
			if player_node.has_method("is_player_defending") and player_node.is_player_defending():
				actual_damage = 0
			var player_health = player_node.get_node_or_null("HealthComponent")
			if player_health and player_health.has_method("take_damage"):
				player_health.take_damage(actual_damage)

				attack_box.set_deferred("monitoring", false)
				attack_box_active = false

func show_hit_feedback() -> void:
	if is_flashing:
		return

	is_flashing = true

	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(animated_sprite, "modulate", Color.WHITE, 0.1)

	await tween.finished
	is_flashing = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackBox" and not is_dead:
		if health_component:
			health_component.take_damage(1)
			show_hit_feedback()

func _on_enemy_health_changed(current: float, _maximum: float) -> void:
	if health_bar_sprite == null:
		return
	health_bar_sprite.visible = true
	if current >= 2:
		health_bar_sprite.texture = bar_full_tex
	elif current >= 1:
		health_bar_sprite.texture = bar_half_tex
	else:
		health_bar_sprite.texture = bar_empty_tex

func _on_died() -> void:
	is_dead = true
	is_attacking = false
	if get_node_or_null("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	LevelTracker.predator_killed(get_path())

	var scene_root := get_tree().current_scene
	if scene_root:
		Coin.spawn_burst(scene_root, animated_sprite.global_position)

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

func _create_bar_texture(left_color: Color, right_color: Color) -> ImageTexture:
	var img = Image.create(40, 8, false, Image.FORMAT_RGBA8)
	for x in range(40):
		for y in range(8):
			if x == 0 or x == 39 or y == 0 or y == 7:
				img.set_pixel(x, y, Color(0.1, 0.1, 0.1))
			elif x < 20:
				img.set_pixel(x, y, left_color)
			else:
				img.set_pixel(x, y, right_color)
	return ImageTexture.create_from_image(img)
