extends Node

# Checkpoint 11: Full Gameplay Loop Verification Test
# This test verifies the scene configuration for the complete gameplay flow

var scene_path = "res://scenes/dunia_2.tscn"
var test_results = []

func _ready():
	print("\n=== CHECKPOINT 11: FULL GAMEPLAY LOOP VERIFICATION ===\n")
	run_all_tests()
	print_results()
	get_tree().quit()

func run_all_tests():
	test_scene_loads()
	test_player_spawn_configuration()
	test_key_configuration()
	test_bonus_item_configuration()
	test_chest_configuration()
	test_exit_portal_configuration()
	test_hazard_configuration()
	test_enemy_configuration()
	test_camera_configuration()
	test_collectible_tracking()

func test_scene_loads():
	var test_name = "Scene Loading"
	var scene = load(scene_path)
	if scene:
		add_result(test_name, true, "Scene loads successfully")
	else:
		add_result(test_name, false, "Scene failed to load")

func test_player_spawn_configuration():
	var test_name = "Player Spawn Configuration"
	var scene = load(scene_path).instantiate()
	
	var player = scene.get_node_or_null("Player")
	if not player:
		add_result(test_name, false, "Player node not found")
		scene.queue_free()
		return
	
	var expected_pos = Vector2(100, 1750)
	var actual_pos = player.position
	var pos_correct = actual_pos.distance_to(expected_pos) < 10
	
	var has_script = player.get_script() != null
	var has_camera = player.get_node_or_null("Camera2D") != null
	
	if pos_correct and has_script and has_camera:
		add_result(test_name, true, "Player spawns at correct position with camera")
	else:
		var msg = "Issues: "
		if not pos_correct:
			msg += "Position incorrect (expected %s, got %s). " % [expected_pos, actual_pos]
		if not has_script:
			msg += "No script attached. "
		if not has_camera:
			msg += "No camera found. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_key_configuration():
	var test_name = "Key Configuration"
	var scene = load(scene_path).instantiate()
	
	var collectibles = scene.get_node_or_null("Collectibles")
	if not collectibles:
		add_result(test_name, false, "Collectibles node not found")
		scene.queue_free()
		return
	
	var keys = []
	for child in collectibles.get_children():
		if child.name.begins_with("Key"):
			keys.append(child)
	
	var expected_count = 3
	var expected_positions = [
		Vector2(1600, 1250),  # Key1
		Vector2(3100, 650),   # Key2
		Vector2(2800, 400)    # Key3
	]
	
	if keys.size() != expected_count:
		add_result(test_name, false, "Expected %d keys, found %d" % [expected_count, keys.size()])
		scene.queue_free()
		return
	
	var all_positioned_correctly = true
	var all_have_scripts = true
	
	for i in range(keys.size()):
		var key = keys[i]
		var expected_pos = expected_positions[i]
		var actual_pos = key.position
		
		if actual_pos.distance_to(expected_pos) > 10:
			all_positioned_correctly = false
		
		if key.get_script() == null:
			all_have_scripts = false
	
	if all_positioned_correctly and all_have_scripts:
		add_result(test_name, true, "All 3 keys configured correctly")
	else:
		var msg = "Issues: "
		if not all_positioned_correctly:
			msg += "Some keys not at expected positions. "
		if not all_have_scripts:
			msg += "Some keys missing scripts. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_bonus_item_configuration():
	var test_name = "Bonus Item Configuration"
	var scene = load(scene_path).instantiate()
	
	var collectibles = scene.get_node_or_null("Collectibles")
	if not collectibles:
		add_result(test_name, false, "Collectibles node not found")
		scene.queue_free()
		return
	
	var bonus_items = []
	for child in collectibles.get_children():
		if child.name.begins_with("BonusItem"):
			bonus_items.append(child)
	
	var expected_count = 3
	var expected_positions = [
		Vector2(1000, 1550),  # BonusItem1
		Vector2(2300, 1150),  # BonusItem2
		Vector2(3600, 550)    # BonusItem3
	]
	
	if bonus_items.size() != expected_count:
		add_result(test_name, false, "Expected %d bonus items, found %d" % [expected_count, bonus_items.size()])
		scene.queue_free()
		return
	
	var all_positioned_correctly = true
	var all_have_scripts = true
	
	for i in range(bonus_items.size()):
		var item = bonus_items[i]
		var expected_pos = expected_positions[i]
		var actual_pos = item.position
		
		if actual_pos.distance_to(expected_pos) > 10:
			all_positioned_correctly = false
		
		if item.get_script() == null:
			all_have_scripts = false
	
	if all_positioned_correctly and all_have_scripts:
		add_result(test_name, true, "All 3 bonus items configured correctly")
	else:
		var msg = "Issues: "
		if not all_positioned_correctly:
			msg += "Some items not at expected positions. "
		if not all_have_scripts:
			msg += "Some items missing scripts. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_chest_configuration():
	var test_name = "Final Chest Configuration"
	var scene = load(scene_path).instantiate()
	
	var chests = scene.get_node_or_null("Chests")
	if not chests:
		add_result(test_name, false, "Chests node not found")
		scene.queue_free()
		return
	
	var final_chest = chests.get_node_or_null("FinalChest")
	if not final_chest:
		add_result(test_name, false, "FinalChest node not found")
		scene.queue_free()
		return
	
	var expected_pos = Vector2(4600, 1750)
	var actual_pos = final_chest.position
	var pos_correct = actual_pos.distance_to(expected_pos) < 10
	
	var has_script = final_chest.get_script() != null
	var required_keys = final_chest.get("required_keys")
	var keys_correct = required_keys == 3
	
	if pos_correct and has_script and keys_correct:
		add_result(test_name, true, "Final chest configured correctly (requires 3 keys)")
	else:
		var msg = "Issues: "
		if not pos_correct:
			msg += "Position incorrect. "
		if not has_script:
			msg += "No script attached. "
		if not keys_correct:
			msg += "Required keys not set to 3 (got %s). " % str(required_keys)
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_exit_portal_configuration():
	var test_name = "Exit Portal Configuration"
	var scene = load(scene_path).instantiate()
	
	var exit_portal = scene.get_node_or_null("ExitPortal")
	if not exit_portal:
		add_result(test_name, false, "ExitPortal node not found")
		scene.queue_free()
		return
	
	var expected_pos = Vector2(4800, 1750)
	var actual_pos = exit_portal.position
	var pos_correct = actual_pos.distance_to(expected_pos) < 10
	
	var has_script = exit_portal.get_script() != null
	var has_sprite = exit_portal.get_node_or_null("Sprite2D") != null
	var has_particles = exit_portal.get_node_or_null("CPUParticles2D") != null
	
	if pos_correct and has_script and has_sprite and has_particles:
		add_result(test_name, true, "Exit portal configured correctly with visual effects")
	else:
		var msg = "Issues: "
		if not pos_correct:
			msg += "Position incorrect. "
		if not has_script:
			msg += "No script attached. "
		if not has_sprite:
			msg += "No sprite found. "
		if not has_particles:
			msg += "No particles found. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_hazard_configuration():
	var test_name = "Hazard Configuration"
	var scene = load(scene_path).instantiate()
	
	var hazards = scene.get_node_or_null("Hazards")
	if not hazards:
		add_result(test_name, false, "Hazards node not found")
		scene.queue_free()
		return
	
	var spike_groups = []
	for child in hazards.get_children():
		if child.name.begins_with("SpikeGroup"):
			spike_groups.append(child)
	
	var moving_platforms_node = scene.get_node_or_null("MovingPlatforms")
	var moving_platforms = []
	if moving_platforms_node:
		for child in moving_platforms_node.get_children():
			if child.name.begins_with("MovingPlatform"):
				moving_platforms.append(child)
	
	var min_spike_groups = 5
	var min_moving_platforms = 2
	
	var spikes_ok = spike_groups.size() >= min_spike_groups
	var platforms_ok = moving_platforms.size() >= min_moving_platforms
	
	if spikes_ok and platforms_ok:
		add_result(test_name, true, "Hazards configured: %d spike groups, %d moving platforms" % [spike_groups.size(), moving_platforms.size()])
	else:
		var msg = "Issues: "
		if not spikes_ok:
			msg += "Expected at least %d spike groups, found %d. " % [min_spike_groups, spike_groups.size()]
		if not platforms_ok:
			msg += "Expected at least %d moving platforms, found %d. " % [min_moving_platforms, moving_platforms.size()]
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_enemy_configuration():
	var test_name = "Enemy Configuration"
	var scene = load(scene_path).instantiate()
	
	var enemies = scene.get_node_or_null("Enemies")
	if not enemies:
		add_result(test_name, false, "Enemies node not found")
		scene.queue_free()
		return
	
	var predator_plants = []
	for child in enemies.get_children():
		if child.name.begins_with("PredatorPlant"):
			predator_plants.append(child)
	
	var expected_count = 5
	
	if predator_plants.size() == expected_count:
		add_result(test_name, true, "All 5 enemies configured correctly")
	else:
		add_result(test_name, false, "Expected %d enemies, found %d" % [expected_count, predator_plants.size()])
	
	scene.queue_free()

func test_camera_configuration():
	var test_name = "Camera Configuration"
	var scene = load(scene_path).instantiate()
	
	var player = scene.get_node_or_null("Player")
	if not player:
		add_result(test_name, false, "Player node not found")
		scene.queue_free()
		return
	
	var camera = player.get_node_or_null("Camera2D")
	if not camera:
		add_result(test_name, false, "Camera2D not found on player")
		scene.queue_free()
		return
	
	var expected_bounds = {
		"left": 0,
		"top": 0,
		"right": 5000,
		"bottom": 2000
	}
	
	var bounds_correct = (
		camera.limit_left == expected_bounds.left and
		camera.limit_top == expected_bounds.top and
		camera.limit_right == expected_bounds.right and
		camera.limit_bottom == expected_bounds.bottom
	)
	
	var smoothing_enabled = camera.position_smoothing_enabled
	
	if bounds_correct and smoothing_enabled:
		add_result(test_name, true, "Camera bounds and smoothing configured correctly")
	else:
		var msg = "Issues: "
		if not bounds_correct:
			msg += "Bounds incorrect (L:%d T:%d R:%d B:%d). " % [camera.limit_left, camera.limit_top, camera.limit_right, camera.limit_bottom]
		if not smoothing_enabled:
			msg += "Smoothing not enabled. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func test_collectible_tracking():
	var test_name = "Collectible Tracking System"
	var scene = load(scene_path).instantiate()
	
	var player = scene.get_node_or_null("Player")
	if not player:
		add_result(test_name, false, "Player node not found")
		scene.queue_free()
		return
	
	# Check if player has the necessary properties for tracking
	var has_carried_keys = "carried_keys" in player
	var has_bawa_kunci = "bawa_kunci" in player
	
	if has_carried_keys and has_bawa_kunci:
		add_result(test_name, true, "Player has collectible tracking properties")
	else:
		var msg = "Issues: "
		if not has_carried_keys:
			msg += "Player missing 'carried_keys' property. "
		if not has_bawa_kunci:
			msg += "Player missing 'bawa_kunci' property. "
		add_result(test_name, false, msg)
	
	scene.queue_free()

func add_result(test_name: String, passed: bool, message: String):
	test_results.append({
		"name": test_name,
		"passed": passed,
		"message": message
	})

func print_results():
	print("\n=== TEST RESULTS ===\n")
	
	var passed_count = 0
	var total_count = test_results.size()
	
	for result in test_results:
		var status = "✓ PASS" if result.passed else "✗ FAIL"
		var color = "\033[32m" if result.passed else "\033[31m"  # Green or Red
		var reset = "\033[0m"
		
		print("%s%s%s: %s" % [color, status, reset, result.name])
		print("  → %s" % result.message)
		print("")
		
		if result.passed:
			passed_count += 1
	
	print("=== SUMMARY ===")
	print("Total Tests: %d" % total_count)
	print("Passed: %d" % passed_count)
	print("Failed: %d" % (total_count - passed_count))
	print("Pass Rate: %.1f%%" % ((float(passed_count) / total_count) * 100.0))
	print("")
	
	if passed_count == total_count:
		print("\033[32m✓ ALL TESTS PASSED - Gameplay loop is ready for testing!\033[0m")
	else:
		print("\033[31m✗ SOME TESTS FAILED - Please review the issues above\033[0m")
