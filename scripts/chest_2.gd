extends Area2D

@onready var sprite = $AnimatedSprite2D
var sudah_terbuka = false
var required_key_type = "key_2"

var player_di_kanan: bool = false
var player_di_kiri: bool = false

func _ready():
	sprite.sprite_frames.set_animation_loop("buka_2", false)
	sprite.animation = "buka_2"
	sprite.frame = 0
	sprite.stop()
	body_shape_entered.connect(_on_body_shape_entered)
	body_shape_exited.connect(_on_body_shape_exited)

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player":
		var owner_id = shape_find_owner(local_shape_index)
		var kotak_masuk = shape_owner_get_owner(owner_id)
		
		if kotak_masuk.name == "kanan":
			player_di_kanan = true
		elif kotak_masuk.name == "kiri":
			player_di_kiri = true
		
		body.set_nearby_chest(self)

func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "player":
		var owner_id = shape_find_owner(local_shape_index)
		var kotak_keluar = shape_owner_get_owner(owner_id)
		
		if kotak_keluar.name == "kanan":
			player_di_kanan = false
		elif kotak_keluar.name == "kiri":
			player_di_kiri = false
		
		if not player_di_kanan and not player_di_kiri:
			body.clear_nearby_chest(self)

func get_interaction_side() -> String:
	if player_di_kiri:
		return "kiri"
	elif player_di_kanan:
		return "kanan"
	return ""

func try_open(_key_type: String) -> bool:
	if sudah_terbuka:
		return false
	
	buka_peti()
	return true

func buka_peti():
	sudah_terbuka = true
	sprite.play("buka_2")
	sprite.animation_finished.connect(_on_animasi_selesai, CONNECT_ONE_SHOT)
	
	var scene_root := get_tree().current_scene
	if scene_root:
		Coin.spawn_burst(scene_root, sprite.global_position)

func _on_animasi_selesai():
	sprite.stop()
	sprite.frame = 4
