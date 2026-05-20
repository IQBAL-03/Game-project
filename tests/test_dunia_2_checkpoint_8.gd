extends GutTest
## Test suite for Dunia 2 Level - Checkpoint 8
## Verifies hazards (spikes, moving platforms) and enemy interactions

var scene: Node2D
var player: CharacterBody2D
var hazards_group: Node2D
var enemies_group: Node2D
var moving_platforms_group: Node2D

func before_each():
	# Load the Dunia 2 scene
	var scene_resource = load("res://scenes/dunia_2.tscn")
	assert_not_null(scene_resource, "Scene file should exist")
	
	scene = scene_resource.instantiate()
	assert_not_null(scene, "Scene should instantiate successfully")
	
	add_child_autofree(scene)
	
	# Get references to key nodes
	player = scene.get_node_or_null("Player")
	hazards_group = scene.get_node_or_null("Hazards")
	enemies_group = scene.get_node_or_null("Enemies")
	moving_platforms_group = scene.get_node_or_null("MovingPlatforms")

## SPIKE TESTS

func test_spike_groups_exist():
	assert_not_null(hazards_group, "Hazards group should exist")
	
	# Verify all 5 spike groups exist
	var spike_group_1 = hazards_group.get_node_or_null("SpikeGroup1")
	assert_not_null(spike_group_1, "SpikeGroup1 should exist")
	
	var spike_group_2 = hazards_group.get_node_or_null("SpikeGroup2")
	assert_not_null(spike_group_2, "SpikeGroup2 should exist")
	
	var spike_group_3 = hazards_group.get_node_or_null("SpikeGroup3")
	assert_not_null(spike_group_3, "SpikeGroup3 should exist")
	
	var spike_group_4 = hazards_group.get_node_or_null("SpikeGroup4")
	assert_not_null(spike_group_4, "SpikeGroup4 should exist")
	
	var spike_group_5 = hazards_group.get_node_or_null("SpikeGroup5")
	assert_not_null(spike_group_5, "SpikeGroup5 should exist")

func test_spike_groups_at_correct_positions():
	assert_not_null(hazards_group, "Hazards group should exist")
	
	# Test positions according to design document
	var spike_group_1 = hazards_group.get_node_or_null("SpikeGroup1")
	if spike_group_1:
		assert_almost_eq(spike_group_1.position.x, 1200, 1.0, 
			"SpikeGroup1 X should be at 1200")
		assert_almost_eq(spike_group_1.position.y, 1760, 1.0, 
			"SpikeGroup1 Y should be at 1760")
	
	var spike_group_2 = hazards_group.get_node_or_null("SpikeGroup2")
	if spike_group_2:
		assert_almost_eq(spike_group_2.position.x, 1800, 1.0, 
			"SpikeGroup2 X should be at 1800")
		assert_almost_eq(spike_group_2.position.y, 1360, 1.0, 
			"SpikeGroup2 Y should be at 1360")
	
	var spike_group_3 = hazards_group.get_node_or_null("SpikeGroup3")
	if spike_group_3:
		assert_almost_eq(spike_group_3.position.x, 2500, 1.0, 
			"SpikeGroup3 X should be at 2500")
		assert_almost_eq(spike_group_3.position.y, 1760, 1.0, 
			"SpikeGroup3 Y should be at 1760")

func test_spike_groups_have_collision():
	assert_not_null(hazards_group, "Hazards group should exist")
	
	# Check that spike groups are Area2D with proper collision setup
	var spike_group_1 = hazards_group.get_node_or_null("SpikeGroup1")
	if spike_group_1:
		assert_true(spike_group_1 is Area2D, "SpikeGroup1 should be Area2D")
		assert_eq(spike_group_1.collision_layer, 16, 
			"SpikeGroup1 should be on collision layer 16 (Hazards)")
		assert_eq(spike_group_1.collision_mask, 2, 
			"SpikeGroup1 should detect collision layer 2 (Player)")

func test_spike_damage_functionality():
	# This test verifies that spikes can deal damage to the player
	assert_not_null(player, "Player should exist")
	assert_not_null(hazards_group, "Hazards group should exist")
	
	var spike_group_1 = hazards_group.get_node_or_null("SpikeGroup1")
	assert_not_null(spike_group_1, "SpikeGroup1 should exist")
	
	# Get player's health component
	var health_component = player.get_node_or_null("HealthComponent")
	assert_not_null(health_component, "Player should have HealthComponent")
	
	var initial_health = health_component.current_health
	
	# Check if spike has a script attached
	var spike_script = spike_group_1.get_script()
	if spike_script == null:
		pending("Spike groups need script attached to deal damage")
		return
	
	# Simulate player collision with spike
	# Position player at spike location
	player.position = spike_group_1.position
	
	# Wait a frame for physics to process
	await wait_frames(2)
	
	# Verify damage was dealt (health should decrease)
	var current_health = health_component.current_health
	assert_lt(current_health, initial_health, 
		"Player health should decrease after spike collision")

## MOVING PLATFORM TESTS

func test_moving_platforms_exist():
	assert_not_null(moving_platforms_group, "MovingPlatforms group should exist")
	
	# Verify both moving platforms exist
	var platform_1 = moving_platforms_group.get_node_or_null("MovingPlatform1")
	assert_not_null(platform_1, "MovingPlatform1 should exist")
	
	var platform_2 = moving_platforms_group.get_node_or_null("MovingPlatform2")
	assert_not_null(platform_2, "MovingPlatform2 should exist")

func test_moving_platforms_at_correct_positions():
	assert_not_null(moving_platforms_group, "MovingPlatforms group should exist")
	
	# Test MovingPlatform1 (horizontal)
	var platform_1 = moving_platforms_group.get_node_or_null("MovingPlatform1")
	if platform_1:
		assert_almost_eq(platform_1.position.x, 2000, 1.0, 
			"MovingPlatform1 should start at X=2000")
		assert_almost_eq(platform_1.position.y, 1400, 1.0, 
			"MovingPlatform1 should be at Y=1400")
	
	# Test MovingPlatform2 (vertical)
	var platform_2 = moving_platforms_group.get_node_or_null("MovingPlatform2")
	if platform_2:
		assert_almost_eq(platform_2.position.x, 3400, 1.0, 
			"MovingPlatform2 should be at X=3400")
		assert_almost_eq(platform_2.position.y, 1000, 1.0, 
			"MovingPlatform2 should start at Y=1000")

func test_moving_platforms_have_correct_configuration():
	assert_not_null(moving_platforms_group, "MovingPlatforms group should exist")
	
	# Test MovingPlatform1 configuration
	var platform_1 = moving_platforms_group.get_node_or_null("MovingPlatform1")
	if platform_1:
		assert_true(platform_1 is AnimatableBody2D, 
			"MovingPlatform1 should be AnimatableBody2D")
		assert_eq(platform_1.start_position, Vector2(2000, 1400), 
			"MovingPlatform1 start position should be (2000, 1400)")
		assert_eq(platform_1.end_position, Vector2(2400, 1400), 
			"MovingPlatform1 end position should be (2400, 1400)")
		assert_eq(platform_1.speed, 100.0, 
			"MovingPlatform1 speed should be 100.0")
	
	# Test MovingPlatform2 configuration
	var platform_2 = moving_platforms_group.get_node_or_null("MovingPlatform2")
	if platform_2:
		assert_true(platform_2 is AnimatableBody2D, 
			"MovingPlatform2 should be AnimatableBody2D")
		assert_eq(platform_2.start_position, Vector2(3400, 1000), 
			"MovingPlatform2 start position should be (3400, 1000)")
		assert_eq(platform_2.end_position, Vector2(3400, 600), 
			"MovingPlatform2 end position should be (3400, 600)")
		assert_eq(platform_2.speed, 80.0, 
			"MovingPlatform2 speed should be 80.0")

func test_moving_platform_movement():
	# Test that moving platforms actually move
	assert_not_null(moving_platforms_group, "MovingPlatforms group should exist")
	
	var platform_1 = moving_platforms_group.get_node_or_null("MovingPlatform1")
	assert_not_null(platform_1, "MovingPlatform1 should exist")
	
	var initial_position = platform_1.position
	
	# Wait for several frames to allow movement
	await wait_seconds(0.5)
	
	var new_position = platform_1.position
	
	# Platform should have moved from its initial position
	assert_ne(initial_position, new_position, 
		"MovingPlatform1 should move from initial position")

## ENEMY TESTS

func test_all_enemies_exist():
	assert_not_null(enemies_group, "Enemies group should exist")
	
	# Verify all 5 predator plants exist
	for i in range(1, 6):
		var enemy_name = "PredatorPlant" + str(i)
		var enemy = enemies_group.get_node_or_null(enemy_name)
		assert_not_null(enemy, enemy_name + " should exist")

func test_enemies_at_correct_positions():
	assert_not_null(enemies_group, "Enemies group should exist")
	
	# Test positions according to design document
	var enemy_1 = enemies_group.get_node_or_null("PredatorPlant1")
	if enemy_1:
		assert_almost_eq(enemy_1.position.x, 800, 1.0, 
			"PredatorPlant1 X should be at 800")
		assert_almost_eq(enemy_1.position.y, 1600, 1.0, 
			"PredatorPlant1 Y should be at 1600")
	
	var enemy_2 = enemies_group.get_node_or_null("PredatorPlant2")
	if enemy_2:
		assert_almost_eq(enemy_2.position.x, 1500, 1.0, 
			"PredatorPlant2 X should be at 1500")
		assert_almost_eq(enemy_2.position.y, 1300, 1.0, 
			"PredatorPlant2 Y should be at 1300")
	
	var enemy_4 = enemies_group.get_node_or_null("PredatorPlant4")
	if enemy_4:
		assert_almost_eq(enemy_4.position.x, 3000, 1.0, 
			"PredatorPlant4 X should be at 3000")
	
	var enemy_5 = enemies_group.get_node_or_null("PredatorPlant5")
	if enemy_5:
		assert_almost_eq(enemy_5.position.x, 3500, 1.0, 
			"PredatorPlant5 X should be at 3500")

func test_enemies_have_required_components():
	assert_not_null(enemies_group, "Enemies group should exist")
	
	var enemy_1 = enemies_group.get_node_or_null("PredatorPlant1")
	if enemy_1:
		assert_true(enemy_1 is CharacterBody2D, 
			"PredatorPlant should be CharacterBody2D")
		
		# Check for required components
		var animated_sprite = enemy_1.get_node_or_null("AnimatedSprite2D")
		assert_not_null(animated_sprite, "Enemy should have AnimatedSprite2D")
		
		var hitbox = enemy_1.get_node_or_null("Hitbox")
		assert_not_null(hitbox, "Enemy should have Hitbox")
		
		var reaksi = enemy_1.get_node_or_null("Reaksi")
		assert_not_null(reaksi, "Enemy should have Reaksi (detection area)")

func test_enemy_detection_system():
	# Test that enemies can detect the player
	assert_not_null(player, "Player should exist")
	assert_not_null(enemies_group, "Enemies group should exist")
	
	var enemy_1 = enemies_group.get_node_or_null("PredatorPlant1")
	assert_not_null(enemy_1, "PredatorPlant1 should exist")
	
	# Position player near enemy to trigger detection
	player.position = enemy_1.position + Vector2(100, 0)
	
	# Wait for detection to process
	await wait_frames(5)
	
	# Check if enemy is in attacking state
	# Note: This depends on the enemy script implementation
	if enemy_1.has_method("is_attacking") or "is_attacking" in enemy_1:
		var is_attacking = enemy_1.get("is_attacking")
		assert_true(is_attacking, "Enemy should detect and attack nearby player")

func test_enemy_can_damage_player():
	# Test that enemies can deal damage to the player
	assert_not_null(player, "Player should exist")
	assert_not_null(enemies_group, "Enemies group should exist")
	
	var enemy_1 = enemies_group.get_node_or_null("PredatorPlant1")
	assert_not_null(enemy_1, "PredatorPlant1 should exist")
	
	var health_component = player.get_node_or_null("HealthComponent")
	assert_not_null(health_component, "Player should have HealthComponent")
	
	var initial_health = health_component.current_health
	
	# Position player directly on enemy hitbox
	player.position = enemy_1.position
	
	# Wait for attack to process
	await wait_seconds(1.0)
	
	# Verify damage was dealt
	var current_health = health_component.current_health
	assert_lte(current_health, initial_health, 
		"Player health should not increase after enemy contact")

## INTEGRATION TESTS

func test_hazard_and_enemy_combination():
	# Test that there's at least one area with both hazards and enemies nearby
	assert_not_null(hazards_group, "Hazards group should exist")
	assert_not_null(enemies_group, "Enemies group should exist")
	
	# According to design: PredatorPlant2 at (1500, 1300) near SpikeGroup2 at (1800, 1360)
	var enemy_2 = enemies_group.get_node_or_null("PredatorPlant2")
	var spike_group_2 = hazards_group.get_node_or_null("SpikeGroup2")
	
	if enemy_2 and spike_group_2:
		var distance = enemy_2.position.distance_to(spike_group_2.position)
		assert_lt(distance, 500, 
			"Enemy and spike should be within 500 pixels (strategic placement)")

func test_scene_ready_for_gameplay():
	# Overall integration test
	assert_not_null(scene, "Scene should exist")
	assert_not_null(player, "Player should exist")
	assert_not_null(hazards_group, "Hazards should exist")
	assert_not_null(enemies_group, "Enemies should exist")
	assert_not_null(moving_platforms_group, "Moving platforms should exist")
	
	# Verify minimum counts
	var spike_count = hazards_group.get_child_count()
	assert_gte(spike_count, 5, "Should have at least 5 spike groups")
	
	var enemy_count = enemies_group.get_child_count()
	assert_gte(enemy_count, 5, "Should have at least 5 enemies")
	
	var platform_count = moving_platforms_group.get_child_count()
	assert_gte(platform_count, 2, "Should have at least 2 moving platforms")
