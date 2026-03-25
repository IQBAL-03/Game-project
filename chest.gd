extends Area2D

@onready var sprite = $AnimatedSprite2D
var sudah_terbuka = false

func _ready():
	sprite.sprite_frames.set_animation_loop("buka", false)
	sprite.animation = "buka"
	sprite.frame = 0
	sprite.stop()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player" and not sudah_terbuka:
		if body.carried_keys.size() > 0:
			buka_peti(body)

func buka_peti(player_node):
	sudah_terbuka = true

	sprite.play("buka")
	sprite.animation_finished.connect(_on_animasi_selesai, CONNECT_ONE_SHOT)

	var kunci_dipakai = player_node.carried_keys.pop_front()
	kunci_dipakai.global_position = Vector2(-99999, -99999)
	kunci_dipakai.target_player = null

	player_node.bawa_kunci = player_node.carried_keys.any(func(k): return k.tipe_kunci == "key")
	player_node.has_key = player_node.carried_keys.any(func(k): return k.tipe_kunci == "key_2")

	for kunci in get_tree().get_nodes_in_group("kunci_group"):
		if kunci.get("target_player") == null:
			kunci.set_deferred("monitoring", true)

func _on_animasi_selesai():
	sprite.stop()
	sprite.frame = 4
