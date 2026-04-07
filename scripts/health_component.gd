extends Node

# Health Component
# Manages health state and damage logic for entities

# Signals
signal health_changed(current: int, maximum: int)
signal died()

# Properties
@export var max_health: int = 3
var current_health: int

func _ready() -> void:
	# Validate max_health
	if max_health < 1:
		push_error("max_health must be at least 1, setting to 1")
		max_health = 1
	
	# Initialize current health to max
	current_health = max_health
	
	# Emit initial state
	health_changed.emit(current_health, max_health)

func take_damage(amount: int) -> void:
	if current_health <= 0:
		return
	
	# Reduce health
	current_health -= amount
	
	# Clamp to valid range
	current_health = clampi(current_health, 0, max_health)
	
	# Emit health changed signal
	health_changed.emit(current_health, max_health)
	
	# Check for death
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	# Increase health
	current_health += amount
	
	# Clamp to valid range
	current_health = clampi(current_health, 0, max_health)
	
	# Emit health changed signal
	health_changed.emit(current_health, max_health)

func get_current_health() -> int:
	return current_health

func get_max_health() -> int:
	return max_health
