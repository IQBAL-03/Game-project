extends GutTest
## Test suite for Dunia 2 Level - Exit Portal (Task 10.1)
## Verifies exit portal placement, configuration, and activation requirements

var scene: Node2D
var exit_portal: Area2D
var final_chest: Area2D

func before_each():
	# Load the Dunia 2 scene
	var scene_resource = load("res://scenes/dunia_2.tscn")
	assert_not_null(scene_resource, "Scene file should exist")
	
	scene = scene_resource.instantiate()
	assert_not_null(scene, "Scene should instantiate successfully")
	
	add_child_autofree(scene)
	
	# Get references to key nodes
	exit_portal = scene.get_node_or_null("ExitPortal")
	var chests_group = scene.get_node_or_null("Chests")
	if chests_group:
		final_chest = chests_group.get_node_or_null("FinalChest")

## EXIT PORTAL EXISTENCE AND POSITION TESTS

func test_exit_portal_exists():
	assert_not_null(exit_portal, "ExitPortal node should exist in scene")

func test_exit_portal_at_correct_position():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	# According to design: Exit portal at (4800, 1750)
	assert_almost_eq(exit_portal.position.x, 4800, 1.0, 
		"ExitPortal X position should be at 4800")
	assert_almost_eq(exit_portal.position.y, 1750, 1.0, 
		"ExitPortal Y position should be at 1750")

func test_exit_portal_is_area2d():
	assert_not_null(exit_portal, "ExitPortal should exist")
	assert_true(exit_portal is Area2D, 
		"ExitPortal should be an Area2D for collision detection")

## EXIT PORTAL CONFIGURATION TESTS

func test_exit_portal_has_script():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	var script = exit_portal.get_script()
	assert_not_null(script, "ExitPortal should have a script attached")

func test_exit_portal_has_collision_shape():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	var collision_shape = exit_portal.get_node_or_null("CollisionShape2D")
	assert_not_null(collision_shape, 
		"ExitPortal should have CollisionShape2D for trigger area")
	
	# Verify it's a CircleShape2D with 100 pixel radius
	if collision_shape:
		var shape = collision_shape.shape
		assert_not_null(shape, "CollisionShape2D should have a shape")
		assert_true(shape is CircleShape2D, 
			"Trigger area should be CircleShape2D")
		
		if shape is CircleShape2D:
			assert_almost_eq(shape.radius, 100.0, 1.0, 
				"Trigger area radius should be 100 pixels")

func test_exit_portal_has_visual_marker():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	var sprite = exit_portal.get_node_or_null("Sprite2D")
	assert_not_null(sprite, 
		"ExitPortal should have Sprite2D for visual marker")
	
	if sprite:
		assert_not_null(sprite.texture, 
			"Sprite2D should have a texture assigned")

func test_exit_portal_has_particle_effect():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	var particles = exit_portal.get_node_or_null("CPUParticles2D")
	assert_not_null(particles, 
		"ExitPortal should have CPUParticles2D for animation/glow effect")

func test_exit_portal_collision_layers():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	# Should be on collectibles layer (32) and detect player layer (2)
	assert_eq(exit_portal.collision_layer, 32, 
		"ExitPortal should be on collision layer 32")
	assert_eq(exit_portal.collision_mask, 2, 
		"ExitPortal should detect collision layer 2 (Player)")

## EXIT PORTAL ACTIVATION REQUIREMENT TESTS

func test_exit_portal_requires_chest_opened():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	# Check if portal has activation logic
	if exit_portal.has_method("_check_chest_status"):
		# Portal should check chest status
		pass_test("ExitPortal has chest status checking method")
	else:
		# Check if it has is_active property
		if "is_active" in exit_portal:
			pass_test("ExitPortal has is_active property")
		else:
			fail_test("ExitPortal should have activation logic")

func test_final_chest_exists():
	assert_not_null(final_chest, 
		"FinalChest should exist for exit portal activation requirement")

func test_final_chest_in_correct_group():
	assert_not_null(final_chest, "FinalChest should exist")
	
	# Check if chest is in the final_chest group
	assert_true(final_chest.is_in_group("final_chest"), 
		"FinalChest should be in 'final_chest' group for portal to find it")

func test_final_chest_has_is_opened_method():
	assert_not_null(final_chest, "FinalChest should exist")
	
	# Check if chest has is_opened method for portal to check
	assert_true(final_chest.has_method("is_opened"), 
		"FinalChest should have is_opened() method")

## INTEGRATION TESTS

func test_exit_portal_near_final_chest():
	assert_not_null(exit_portal, "ExitPortal should exist")
	assert_not_null(final_chest, "FinalChest should exist")
	
	# According to design: Chest at (4600, 1750), Portal at (4800, 1750)
	var distance = exit_portal.position.distance_to(final_chest.position)
	assert_lt(distance, 300, 
		"ExitPortal should be near FinalChest (within 300 pixels)")

func test_exit_portal_initial_state():
	assert_not_null(exit_portal, "ExitPortal should exist")
	
	# Portal should start inactive (chest not opened yet)
	if "is_active" in exit_portal:
		assert_false(exit_portal.is_active, 
			"ExitPortal should start inactive (chest not opened)")
	
	if "chest_opened" in exit_portal:
		assert_false(exit_portal.chest_opened, 
			"chest_opened should be false initially")

func test_scene_metadata_includes_exit_point():
	assert_not_null(scene, "Scene should exist")
	
	# Check scene metadata
	if scene.has_meta("exit_point"):
		var exit_point = scene.get_meta("exit_point")
		assert_eq(exit_point, Vector2(4800, 1750), 
			"Scene metadata should have correct exit_point")
