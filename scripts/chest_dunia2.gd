extends Area2D

# Chest for Dunia 2 - requires all 3 keys to open
@export var required_keys: int = 3

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
		if body.carried_keys.size() >= required_keys:
			buka_peti(body)
		else:
			var keys_needed = required_keys - body.carried_keys.size()
			print("Butuh %d kunci lagi!" % keys_needed)

func buka_peti(player_node):
	sudah_terbuka = true
	sprite.play("buka")
	sprite.animation_finished.connect(_on_animasi_selesai, CONNECT_ONE_SHOT)

	# Consume all keys
	for kunci in player_node.carried_keys:
		kunci.queue_free()
	player_node.carried_keys.clear()
	player_node.bawa_kunci = false
	player_node.has_key = false

	# Notify exit portal
	var exit_portal = get_tree().get_first_node_in_group("exit_portal")
	if exit_portal and exit_portal.has_method("notify_chest_opened"):
		exit_portal.notify_chest_opened()

	print("Peti terbuka! Sekarang pergi ke portal keluar!")

func _on_animasi_selesai():
	sprite.stop()
	sprite.frame = 4
