extends Area2D

@onready var sprite = $AnimatedSprite2D
var target_player = null
var bob_origin_y: float = 0.0

@export var follow_offset: Vector2 = Vector2(-610, -500)

func _ready():
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
		if body.has_key:
			return  # player sudah membawa kunci, tidak bisa ambil lagi
		target_player = body
		target_player.has_key = true
		set_deferred("monitoring", false)
