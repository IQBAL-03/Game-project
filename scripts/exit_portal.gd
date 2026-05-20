extends Area2D

# Exit portal that activates after final chest is opened
# Validates: Requirements 6.2, 6.3, 6.5

@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D
var is_active = false
var chest_opened = false

func _ready():
	body_entered.connect(_on_body_entered)
	monitoring = true
	
	# Check if chest is already opened
	_check_chest_status()
	
	# Update visual based on activation status
	_update_visual()

func _check_chest_status():
	# Find the final chest in the scene
	var chest = get_tree().get_first_node_in_group("final_chest")
	if chest and chest.has_method("is_opened"):
		chest_opened = chest.is_opened()
	elif chest and chest.get("sudah_terbuka"):
		chest_opened = chest.sudah_terbuka
	
	is_active = chest_opened

func _process(_delta):
	# Continuously check chest status
	if not chest_opened:
		_check_chest_status()
		if chest_opened:
			_activate_portal()

func _activate_portal():
	is_active = true
	_update_visual()
	print("Exit portal activated!")

func _update_visual():
	if is_active:
		# Portal is active - show glowing effect
		if sprite:
			sprite.modulate = Color(0.4, 1.0, 0.4, 1.0)  # Green glow
		if particles:
			particles.emitting = true
	else:
		# Portal is inactive - show dimmed
		if sprite:
			sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)  # Gray/dimmed
		if particles:
			particles.emitting = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		if is_active:
			_complete_level()
		else:
			print("Complete the objective first - open the final chest!")

func _complete_level():
	print("Level Complete!")
	# TODO: Implement level completion logic
	# This could trigger:
	# - Level complete screen
	# - Save progress
	# - Load next level
	# - Return to level select
	
	# For now, just reload the scene as a placeholder
	# get_tree().reload_current_scene()
