extends CharacterBody2D

@export var attack_speed: float = 1.0
@export var flip_offset: float = 0.0
@export var damage_amount: float = 0.5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var reaksi: Area2D = $Reaksi
@onready var attack_box: Area2D = null  

var player: CharacterBody2D
var is_dead: bool = false
var is_attacking: bool = false
var attack_box_active: bool = false

var original_sprite_pos_x: float = 0.0
var sprite_local_center: Vector2 = Vector2.ZERO


var player_di_kanan: bool = false
var player_di_kiri: bool = false

func _ready() -> void:
	original_sprite_pos_x = animated_sprite.position.x
	sprite_local_center = animated_sprite.position

	animated_sprite.play("idle")

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
	attack_shape.size = Vector2(60, 60)  
	attack_collision.shape = attack_shape
	attack_collision.position = Vector2(20, 23)  
	attack_box.add_child(attack_collision)
	
	attack_box.area_entered.connect(_on_attack_box_area_entered)

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


	if player_di_kanan or player_di_kiri:
		if not is_attacking:
			is_attacking = true


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

		if is_attacking:
			animated_sprite.play("idle")
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			is_attacking = false
			
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
	if animated_sprite.animation == "serang_kiri":
		
		if attack_box:
			attack_box.set_deferred("monitoring", false)
			attack_box_active = false

		if is_attacking and (player_di_kanan or player_di_kiri):
			animated_sprite.play("serang_kiri")
		else:
			animated_sprite.play("idle")
			animated_sprite.flip_h = false
			animated_sprite.position.x = original_sprite_pos_x
			is_attacking = false

func _on_sprite_frame_changed() -> void:
	
	if animated_sprite.animation == "serang_kiri" and is_attacking:
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
			var health_component = player_node.get_node_or_null("HealthComponent")
			if health_component and health_component.has_method("take_damage"):
				health_component.take_damage(damage_amount)
				
				attack_box.set_deferred("monitoring", false)
				attack_box_active = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "AttackBox" and not is_dead:
		is_dead = true
		is_attacking = false


		$CollisionShape2D.set_deferred("disabled", true)


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
