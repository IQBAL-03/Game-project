extends Area2D

@onready var sprite = $AnimatedSprite2D
var tipe_kunci = "key"

func _ready():
	add_to_group("kunci_group")
	sprite.play("Key")
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		if body.add_key_to_inventory(tipe_kunci):
			queue_free()
