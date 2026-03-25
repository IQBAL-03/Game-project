extends Area2D

@onready var sprite = $AnimatedSprite2D
var target_player = null
var bob_origin_y: float = 0.0
var tipe_kunci = "key_2"

@export var follow_offset: Vector2 = Vector2(40, -970)

func _ready():
	add_to_group("kunci_group")
	sprite.play("Key")
	bob_origin_y = global_position.y
	body_entered.connect(_on_body_entered)

func _process(delta):
	if target_player:
		var target_pos = target_player.global_position + follow_offset
		global_position = global_position.lerp(target_pos, 10 * delta)
	else:
		global_position.y = bob_origin_y + sin(Time.get_ticks_msec() * 0.003) * 8.0

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "player" and target_player == null:
		if body.carried_keys.size() >= 1:
			return
		target_player = body
		body.carried_keys.append(self)
		body.has_key = true
		top_level = true
		set_deferred("monitoring", false)
