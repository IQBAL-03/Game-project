extends Area2D

@export var detection_radius: float = 100.0
@export var animation_speed: float = 1.0
@export var flip_offset: float = 140

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D
var detection_area: Area2D

var is_player_detected: bool = false
var original_sprite_pos_x: float = 0.0
@onready var main_collision_shape: CollisionShape2D = $CollisionShape2D
var original_main_collision_pos_x: float = 0.0


func _ready() -> void:
	original_sprite_pos_x = animated_sprite.position.x
	if main_collision_shape:
		original_main_collision_pos_x = main_collision_shape.position.x
	animated_sprite.animation = "predator_plant"
	animated_sprite.frame = 0
	animated_sprite.stop()
	
	detection_area = Area2D.new()
	detection_area.name = "DetectionArea"
	detection_area.position = animated_sprite.position
	add_child(detection_area)
	
	var shape = CircleShape2D.new()
	shape.radius = detection_radius
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	detection_area.add_child(collision_shape)
	
	detection_area.collision_layer = 0
	detection_area.collision_mask = 1
	
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if is_player_detected and is_instance_valid(player):
		var stable_center_x = to_global(Vector2(original_sprite_pos_x, 0)).x
		var dir_x = player.global_position.x - stable_center_x
		
		if abs(dir_x) > 2.0:
			if dir_x > 0:
				animated_sprite.flip_h = true
				animated_sprite.position.x = original_sprite_pos_x + flip_offset
				detection_area.position.x = original_sprite_pos_x + flip_offset
				if main_collision_shape:
					main_collision_shape.position.x = original_main_collision_pos_x + flip_offset
			else:
				animated_sprite.flip_h = false
				animated_sprite.position.x = original_sprite_pos_x
				detection_area.position.x = original_sprite_pos_x
				if main_collision_shape:
					main_collision_shape.position.x = original_main_collision_pos_x


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		is_player_detected = true
		animated_sprite.play("predator_plant")
		animated_sprite.speed_scale = animation_speed


func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		is_player_detected = false
		animated_sprite.stop()
		animated_sprite.frame = 0
		player = null


func set_detection_radius(radius: float) -> void:
	if radius <= 0:
		push_warning("Detection radius must be positive, got: ", radius)
		return
	
	detection_radius = radius
	if detection_area and detection_area.get_child_count() > 0:
		var collision_shape = detection_area.get_child(0)
		if collision_shape is CollisionShape2D and collision_shape.shape is CircleShape2D:
			collision_shape.shape.radius = radius


func set_animation_speed(speed: float) -> void:
	if speed <= 0:
		push_warning("Animation speed must be positive, got: ", speed)
		return
	
	animation_speed = speed
	if is_player_detected:
		animated_sprite.speed_scale = speed
