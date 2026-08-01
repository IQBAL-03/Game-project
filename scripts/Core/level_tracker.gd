extends Node

var chests_opened: Array[String] = []
var predators_killed: Array[String] = []
var level_stars: Dictionary = {}

func _ready() -> void:
	# Selalu reset data bintang setiap kali game/code di-run (tahap pengembangan)
	clear_all_saved_data()

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

func set_level_stars(level_num: int, stars: int) -> void:
	var current = level_stars.get(level_num, 0)
	if stars > current:
		level_stars[level_num] = stars
		save_level_data()

func get_level_stars(level_num: int) -> int:
	return level_stars.get(level_num, 0)

func save_level_data() -> void:
	var config = ConfigFile.new()
	for key in level_stars:
		config.set_value("stars", str(key), level_stars[key])
	config.save("user://level_stars.cfg")

func clear_all_saved_data() -> void:
	level_stars.clear()
	chests_opened.clear()
	predators_killed.clear()
	if FileAccess.file_exists("user://level_stars.cfg"):
		DirAccess.remove_absolute("user://level_stars.cfg")

func reset() -> void:
	chests_opened.clear()
	predators_killed.clear()
