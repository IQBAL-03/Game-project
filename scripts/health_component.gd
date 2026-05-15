extends Node

signal health_changed(current: int, maximum: int)
signal died()

@export var max_health: int = 5
var current_health: float

func _ready() -> void:
	
	if max_health < 1:
		push_error("max_health must be at least 1, setting to 1")
		max_health = 1
	
	current_health = float(max_health)
	
	health_changed.emit(current_health, max_health)

func take_damage(amount, ignore_evasion: bool = false) -> void:
	if current_health <= 0:
		return
	
	var parent = get_parent()
	if not ignore_evasion and parent.has_method("is_evading"):
		if parent.is_evading():
			return
	
	current_health -= amount
	
	current_health = clampf(current_health, 0.0, float(max_health))
	
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		died.emit()

func heal(amount: float) -> void:
	
	current_health += amount
	
	current_health = clampf(current_health, 0.0, float(max_health))
	
	health_changed.emit(current_health, max_health)

func get_current_health() -> float:
	return current_health

func get_max_health() -> float:
	return float(max_health)
