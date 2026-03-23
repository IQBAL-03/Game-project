extends Node2D 

@onready var sprite = $AnimatedSprite2D

func _ready():
	
	sprite.play("Key")

func _process(_delta):
	position.y += sin(Time.get_ticks_msec() * 0.005) * 0.2
