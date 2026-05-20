extends Area2D

@onready var sprite = $AnimatedSprite2D
var bob_origin_y: float = 0.0

func _ready():
	add_to_group("bonus_items")
	sprite.play("shine")
	bob_origin_y = global_position.y
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta):
	# Bobbing animation
	global_position.y = bob_origin_y + sin(Time.get_ticks_msec() * 0.003) * 8.0

func _on_body_entered(body):
	if body.name == "Player":
		# Increment bonus items collected
		if body.has_method("collect_bonus_item"):
			body.collect_bonus_item()
		
		# Remove the bonus item
		queue_free()
