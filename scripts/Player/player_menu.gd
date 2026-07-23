extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if sprite:
		sprite.play("idle")
		sprite.flip_h = false
