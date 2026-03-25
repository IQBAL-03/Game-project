extends Area2D

@onready var sprite = $AnimatedSprite2D
var target_player = null
var bob_origin_y: float = 0.0
var tipe_kunci = "key"

@export var follow_offset: Vector2 = Vector2(-610, -500)

func _ready():
	add_to_group("kunci_group")
	sprite.play("Key")
	bob_origin_y = global_position.y
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta):
	if target_player:
		var target_pos = target_player.global_position + follow_offset
		global_position = global_position.lerp(target_pos, 10 * delta)
	else:
		global_position.y = bob_origin_y + sin(Time.get_ticks_msec() * 0.003) * 8.0

func _on_body_entered(body):
	if body.name == "player" and target_player == null:
		if body.carried_keys.size() >= 1:
			return
		
		target_player = body
		body.carried_keys.append(self)
		body.bawa_kunci = true
		
		top_level = true
		
		set_deferred("monitoring", false)
