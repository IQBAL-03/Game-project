extends AnimatableBody2D

## Moving platform that moves between two positions
## Can move horizontally or vertically in a linear pattern

@export var start_position: Vector2 = Vector2.ZERO
@export var end_position: Vector2 = Vector2.ZERO
@export var speed: float = 100.0
@export var movement_type: String = "linear"  # linear, smooth

var _current_target: Vector2
var _moving_to_end: bool = true
var _initial_position: Vector2

func _ready():
	_initial_position = position
	
	# If start_position is not set, use current position
	if start_position == Vector2.ZERO:
		start_position = position
	
	# Set initial position
	position = start_position
	_current_target = end_position

func _physics_process(delta):
	if start_position == end_position:
		return
	
	# Calculate direction and distance
	var direction = (_current_target - position).normalized()
	var distance_to_target = position.distance_to(_current_target)
	
	# Move towards target
	var movement = direction * speed * delta
	
	# Check if we'll overshoot the target
	if movement.length() >= distance_to_target:
		# Snap to target and switch direction
		position = _current_target
		_switch_target()
	else:
		# Move normally
		position += movement

func _switch_target():
	"""Switch between start and end positions"""
	if _moving_to_end:
		_current_target = start_position
		_moving_to_end = false
	else:
		_current_target = end_position
		_moving_to_end = true
