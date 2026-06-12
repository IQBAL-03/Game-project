class_name Coin
extends Area2D

const COIN_SCENE := preload("res://scenes/Objects/coin.tscn")

@export var coin_value: int = 1

var coin_gravity := 800.0
var player: CharacterBody2D = null
var velocity := Vector2.ZERO
var is_collecting := false
var is_grounded := false
var coin_sprite: Sprite2D = null
var bounce_count := 0
var _wait_frame := 2
var _pending_spawn_pos: Vector2 = Vector2.ZERO


static func spawn_burst(parent: Node, world_position: Vector2, amount: int = 5) -> void:
	if parent == null:
		return
	for i in amount:
		var coin: Coin = COIN_SCENE.instantiate()
		coin._pending_spawn_pos = world_position + Vector2(randf_range(-30, 30), randf_range(-15, 5))
		parent.call_deferred("add_child", coin)


func _ready() -> void:
	if _pending_spawn_pos != Vector2.ZERO:
		global_position = _pending_spawn_pos

	coin_sprite = Sprite2D.new()
	coin_sprite.texture = _create_coin_texture()
	coin_sprite.scale = Vector2(0.8, 0.8)
	add_child(coin_sprite)

	velocity = Vector2(randf_range(-60, 60), randf_range(-200, -300))
	add_to_group("coins")
	call_deferred("_connect_signals")


func _connect_signals() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _wait_frame > 0:
		_wait_frame -= 1
		velocity = Vector2.ZERO
		return

	if is_collecting and player:
		var direction := (player.global_position - global_position).normalized()
		global_position += direction * 500.0 * delta

		if coin_sprite:
			coin_sprite.scale = coin_sprite.scale.lerp(Vector2(0.5, 0.5), 5.0 * delta)

		if global_position.distance_to(player.global_position) < 20.0:
			_collect()
		return

	if is_grounded:
		velocity = Vector2.ZERO
		if coin_sprite:
			coin_sprite.rotation = sin(Time.get_ticks_msec() / 300.0) * 0.15
		return

	velocity.y += coin_gravity * delta
	global_position += velocity * delta

	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, 10))
	query.collision_mask = 1
	var result := space_state.intersect_ray(query)

	if result:
		if bounce_count < 1:
			velocity.y = -velocity.y * 0.3
			velocity.x *= 0.5
			bounce_count += 1
		else:
			is_grounded = true
			velocity = Vector2.ZERO

	if coin_sprite:
		coin_sprite.rotation += 5.0 * delta

	if global_position.y > 5000.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_collecting:
		player = body as CharacterBody2D
		is_collecting = true


func _collect() -> void:
	if player and player.has_method("collect_coin"):
		player.collect_coin(coin_value)
	queue_free()


func _create_coin_texture() -> ImageTexture:
	var size := 24
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(size / 2.0, size / 2.0)
	var radius := 11.0
	var inner_radius := 9.0

	for x in range(size):
		for y in range(size):
			var dist := Vector2(x + 0.5, y + 0.5).distance_to(center)
			if dist <= radius:
				if dist <= inner_radius:
					var brightness := 1.0 - (dist / inner_radius) * 0.25
					img.set_pixel(x, y, Color(0.95 * brightness, 0.78 * brightness, 0.2 * brightness))
				else:
					img.set_pixel(x, y, Color(0.6, 0.45, 0.1))
			else:
				img.set_pixel(x, y, Color(0, 0, 0, 0))

	for x in range(6, 10):
		for y in range(5, 8):
			var dist := Vector2(x + 0.5, y + 0.5).distance_to(center)
			if dist <= inner_radius - 1:
				img.set_pixel(x, y, Color(1.0, 0.95, 0.55))

	var cx := int(center.x)
	var cy := int(center.y)
	for i in range(-3, 4):
		if cx + i >= 0 and cx + i < size:
			img.set_pixel(cx + i, cy, Color(0.75, 0.6, 0.15))
		if cy + i >= 0 and cy + i < size:
			img.set_pixel(cx, cy + i, Color(0.75, 0.6, 0.15))

	return ImageTexture.create_from_image(img)
