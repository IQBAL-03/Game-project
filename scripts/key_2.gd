extends Area2D

@onready var sprite = $AnimatedSprite2D
var tipe_kunci = "key_2"

func _ready():
	add_to_group("kunci_group")
	sprite.play("Key")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and body.name == "player":
		if body.add_key_to_inventory(tipe_kunci):
			queue_free()
