extends CharacterBody2D

const kecepatan = 150.0
const kekuatan_loncat = -350.0

var gravitasi = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravitasi * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = kekuatan_loncat

	var arah = Input.get_axis("ui_left", "ui_right")
	if arah != 0:
		velocity.x = arah * kecepatan
		sprite.play("jalan_kanan")
		sprite.flip_h = (arah < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, kecepatan)
		if is_on_floor():
			sprite.stop()

	move_and_slide()
