extends Node

var chests_opened: Array[String] = []
var predators_killed: Array[String] = []

func chest_opened(chest_id: String) -> void:
	if not chests_opened.has(chest_id):
		chests_opened.append(chest_id)

func predator_killed(predator_id: String) -> void:
	if not predators_killed.has(predator_id):
		predators_killed.append(predator_id)

func get_total_chests() -> int:
	return chests_opened.size()

func get_total_predators() -> int:
	return predators_killed.size()

func calculate_stars(expected_chests: int, expected_predators: int) -> int:
	var chests = get_total_chests()
	var predators = get_total_predators()
	
	var chest_completion = float(chests) / float(expected_chests) if expected_chests > 0 else 0.0
	var predator_completion = float(predators) / float(expected_predators) if expected_predators > 0 else 0.0
	
	var total_completion = (chest_completion + predator_completion) / 2.0
	
	if total_completion >= 0.9:
		return 3
	elif total_completion >= 0.6:
		return 2
	else:
		return 1

func reset() -> void:
	chests_opened.clear()
	predators_killed.clear()
