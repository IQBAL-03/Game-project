extends CharacterBody2D

const kecepatan = 150.0
const kekuatan_loncat = -350.0

var bisa_double_jump = false
var has_key: bool = false
var gravitasi = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

func _ready():
	floor_max_angle = deg_to_rad(60.0)
	floor_snap_length = 8.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravitasi * delta
	else:
		bisa_double_jump = true

	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = kekuatan_loncat
		elif bisa_double_jump:
			velocity.y = kekuatan_loncat
			bisa_double_jump = false

	var arah = Input.get_axis("ui_left", "ui_right")
	
	if arah != 0:
		velocity.x = arah * kecepatan
		sprite.flip_h = (arah < 0)
		
		if sprite.animation != "jalan" or !sprite.is_playing():
			sprite.play("jalan")
	else:
		velocity.x = move_toward(velocity.x, 0, kecepatan)
		
		if abs(velocity.x) < 10:
			sprite.stop()
			sprite.frame = 0

	move_and_slide()
