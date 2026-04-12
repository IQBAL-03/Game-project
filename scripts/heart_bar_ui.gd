extends CanvasLayer

@export var heart_full_texture: Texture2D
@export var heart_empty_texture: Texture2D
@export var heart_spacing: int = 8
@export var heart_size: Vector2 = Vector2(40, 40)  

@onready var hearts_container: HBoxContainer = $MarginContainer/HBoxContainer

var heart_icons: Array[TextureRect] = []

func _ready() -> void:
	
	if heart_full_texture == null or heart_empty_texture == null:
		push_error("Heart textures not assigned in HeartBarUI")
	
	if hearts_container:
		hearts_container.add_theme_constant_override("separation", heart_spacing)
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		
		var health_component = player.get_node_or_null("HealthComponent")
		if health_component:
			
			var max_health = health_component.get_max_health()
			initialize(max_health)
			
			health_component.health_changed.connect(_on_health_changed)
			
			var current_health = health_component.get_current_health()
			update_hearts(current_health, max_health)
		else:
			push_error("Player does not have HealthComponent")
	else:
		push_error("Player not found in scene")

func initialize(max_hearts: int) -> void:
	"""Create TextureRect nodes for each heart based on max_hearts"""
	
	for heart in heart_icons:
		heart.queue_free()
	heart_icons.clear()
	
	for i in range(max_hearts):
		var heart_icon = TextureRect.new()
		heart_icon.texture = heart_full_texture
		heart_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart_icon.custom_minimum_size = heart_size  
		hearts_container.add_child(heart_icon)
		heart_icons.append(heart_icon)

func update_hearts(current: int, maximum: int) -> void:
	"""Update heart textures based on current and maximum health"""
	
	if heart_icons.size() != maximum:
		initialize(maximum)
	
	for i in range(heart_icons.size()):
		if i < current:
			heart_icons[i].texture = heart_full_texture
		else:
			heart_icons[i].texture = heart_empty_texture

func _on_health_changed(_current: int, _maximum: int) -> void:
	"""Callback when player health changes"""
	update_hearts(_current, _maximum)
