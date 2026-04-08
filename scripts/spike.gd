extends Area2D

## Spike hazard that deals damage to the player on contact
## Configured to work with collision layer 16 (hazards) and mask 2 (player)

@export var damage: int = 1

func _ready() -> void:
	# Connect the body_entered signal to handle player collision
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("player"):
		# Get player's health component
		var health_component = body.get_node_or_null("HealthComponent")
		
		# Apply damage if health component exists
		if health_component and health_component.has_method("take_damage"):
			health_component.take_damage(damage)
