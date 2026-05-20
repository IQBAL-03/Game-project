extends Area2D

@export var required_keys: int = 3
@onready var sprite = $AnimatedSprite2D
var sudah_terbuka = false

func _ready():
	add_to_group("final_chest")
	sprite.sprite_frames.set_animation_loop("buka", false)
	sprite.animation = "buka"
	sprite.frame = 0
	sprite.stop()
	body_entered.connect(_on_body_entered)

func is_opened() -> bool:
	return sudah_terbuka

func _on_body_entered(body):
	if body.name == "player" and not sudah_terbuka:
		if body.carried_keys.size() >= required_keys:
			buka_peti(body)
		else:
			# Show message that more keys are needed
			var keys_needed = required_keys - body.carried_keys.size()
			print("Need ", keys_needed, " more key(s) to open this chest")

func buka_peti(player_node):
	sudah_terbuka = true
	
	sprite.play("buka")
	sprite.animation_finished.connect(_on_animasi_selesai, CONNECT_ONE_SHOT)
	
	# Remove all required keys
	for i in range(required_keys):
		if player_node.carried_keys.size() > 0:
			var kunci_dipakai = player_node.carried_keys.pop_front()
			kunci_dipakai.queue_free()
	
	# Update player key status
	player_node.bawa_kunci = player_node.carried_keys.any(func(k): return k.tipe_kunci == "key")
	player_node.has_key = player_node.carried_keys.any(func(k): return k.tipe_kunci == "key_2")
	
	# Re-enable remaining keys in the world
	for kunci in get_tree().get_nodes_in_group("kunci_group"):
		if kunci.get("target_player") == null and not kunci.is_queued_for_deletion():
			kunci.set_deferred("monitoring", true)

func _on_animasi_selesai():
	sprite.stop()
	sprite.frame = 4
