extends Node





signal health_changed(current: int, maximum: int)
signal died()


@export var max_health: int = 5
var current_health: int

func _ready() -> void:
	
	if max_health < 1:
		push_error("max_health must be at least 1, setting to 1")
		max_health = 1
	
	
	current_health = max_health
	
	
	health_changed.emit(current_health, max_health)

func take_damage(amount) -> void:
	if current_health <= 0:
		return
	
	
	var damage_amount = ceili(amount) if amount is float else amount
	current_health -= damage_amount
	
	
	current_health = clampi(current_health, 0, max_health)
	
	
	health_changed.emit(current_health, max_health)
	
	
	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	
	current_health += amount
	
	
	current_health = clampi(current_health, 0, max_health)
	
	
	health_changed.emit(current_health, max_health)

func get_current_health() -> int:
	return current_health

func get_max_health() -> int:
	return max_health
