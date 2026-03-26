extends Area2D

# Configuration properties
@export var detection_radius: float = 100.0
@export var animation_speed: float = 1.0

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var player: CharacterBody2D
var detection_area: Area2D

# State tracking
var is_player_detected: bool = false


func _ready() -> void:
	# Setup animation
	animated_sprite.animation = "predator_plant"
	animated_sprite.frame = 0
	animated_sprite.stop()
	
	# Setup detection area
	detection_area = Area2D.new()
	detection_area.name = "DetectionArea"
	add_child(detection_area)
	
	# Create and configure collision shape
	var shape = CircleShape2D.new()
	shape.radius = detection_radius
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = shape
	detection_area.add_child(collision_shape)
	
	# Configure collision layers
	detection_area.collision_layer = 0
	detection_area.collision_mask = 1
	
	# Connect signals
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	if body.name == "player":
		player = body
		is_player_detected = true
		animated_sprite.play("predator_plant")
		animated_sprite.speed_scale = animation_speed
		print("Player detected! Playing animation")


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
