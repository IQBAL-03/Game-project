extends GutTest
## Test suite for Dunia 2 Level - Checkpoint 5
## Verifies basic scene loading, player spawn, and camera configuration

var scene: Node2D
var player: CharacterBody2D
var camera: Camera2D

func before_each():
	# Load the Dunia 2 scene
	var scene_resource = load("res://scenes/dunia_2.tscn")
	assert_not_null(scene_resource, "Scene file should exist")
	
	scene = scene_resource.instantiate()
	assert_not_null(scene, "Scene should instantiate successfully")
	
	add_child_autofree(scene)
	
	# Get player and camera references
	player = scene.get_node_or_null("Player")
	if player:
		camera = player.get_node_or_null("Camera2D")

func test_scene_loads_without_errors():
	assert_not_null(scene, "Scene should load successfully")
	assert_true(scene.is_inside_tree(), "Scene should be in the scene tree")

func test_player_spawns_at_correct_position():
	assert_not_null(player, "Player node should exist in scene")
	
	var expected_spawn = Vector2(100, 1750)
	var actual_position = player.position
	
	# Allow small tolerance for floating point comparison
	var tolerance = 1.0
	assert_almost_eq(actual_position.x, expected_spawn.x, tolerance, 
		"Player X position should be at spawn point (100)")
	assert_almost_eq(actual_position.y, expected_spawn.y, tolerance, 
		"Player Y position should be at spawn point (1750)")

func test_player_has_required_components():
	assert_not_null(player, "Player node should exist")
	assert_true(player is CharacterBody2D, "Player should be a CharacterBody2D")
	
	# Check for required child nodes
	var animated_sprite = player.get_node_or_null("AnimatedSprite2D")
	assert_not_null(animated_sprite, "Player should have AnimatedSprite2D")
	
	var collision_shape = player.get_node_or_null("Badan")
	assert_not_null(collision_shape, "Player should have collision shape")
	
	var health_component = player.get_node_or_null("HealthComponent")
	assert_not_null(health_component, "Player should have HealthComponent")

func test_camera_exists_and_attached_to_player():
	assert_not_null(camera, "Camera2D should exist as child of Player")
	assert_true(camera is Camera2D, "Camera should be a Camera2D node")

func test_camera_has_proper_bounds():
	assert_not_null(camera, "Camera should exist")
	
	# Verify camera limits match design specifications
	assert_eq(camera.limit_left, 0, "Camera left limit should be 0")
	assert_eq(camera.limit_top, 0, "Camera top limit should be 0")
	assert_eq(camera.limit_right, 5000, "Camera right limit should be 5000")
	assert_eq(camera.limit_bottom, 2000, "Camera bottom limit should be 2000")

func test_camera_smoothing_enabled():
	assert_not_null(camera, "Camera should exist")
	
	assert_true(camera.position_smoothing_enabled, 
		"Camera position smoothing should be enabled")
	assert_eq(camera.position_smoothing_speed, 5.0, 
		"Camera smoothing speed should be 5.0")

func test_scene_has_required_node_groups():
	assert_not_null(scene, "Scene should exist")
	
	# Check for required node groups
	var enemies_group = scene.get_node_or_null("Enemies")
	assert_not_null(enemies_group, "Scene should have Enemies group node")
	
	var hazards_group = scene.get_node_or_null("Hazards")
	assert_not_null(hazards_group, "Scene should have Hazards group node")
	
	var collectibles_group = scene.get_node_or_null("Collectibles")
	assert_not_null(collectibles_group, "Scene should have Collectibles group node")
	
	var moving_platforms_group = scene.get_node_or_null("MovingPlatforms")
	assert_not_null(moving_platforms_group, "Scene should have MovingPlatforms group node")

func test_tilemap_exists_and_configured():
	var tilemap = scene.get_node_or_null("TileMap")
	assert_not_null(tilemap, "TileMap should exist in scene")
	assert_true(tilemap is TileMapLayer, "TileMap should be a TileMapLayer")
	
	# Verify collision is enabled
	assert_true(tilemap.collision_enabled, "TileMap collision should be enabled")
	
	# Verify collision layer (should be layer 1 for platforms)
	assert_eq(tilemap.collision_layer, 1, "TileMap should be on collision layer 1 (Platforms)")

func test_background_parallax_exists():
	var background = scene.get_node_or_null("Background")
	assert_not_null(background, "ParallaxBackground should exist")
	assert_true(background is ParallaxBackground, "Background should be ParallaxBackground")
	
	# Check for required parallax layers
	var sky_layer = background.get_node_or_null("SkyLayer")
	assert_not_null(sky_layer, "Sky parallax layer should exist")
	
	var clouds_layer = background.get_node_or_null("CloudsLayer")
	assert_not_null(clouds_layer, "Clouds parallax layer should exist")
	
	var trees_layer = background.get_node_or_null("TreesLayer")
	assert_not_null(trees_layer, "Trees parallax layer should exist")

func test_parallax_layers_have_correct_scroll_speeds():
	var background = scene.get_node_or_null("Background")
	assert_not_null(background, "Background should exist")
	
	var sky_layer = background.get_node_or_null("SkyLayer")
	if sky_layer:
		assert_almost_eq(sky_layer.motion_scale.x, 0.1, 0.01, 
			"Sky layer should have scroll speed 0.1")
	
	var clouds_layer = background.get_node_or_null("CloudsLayer")
	if clouds_layer:
		assert_almost_eq(clouds_layer.motion_scale.x, 0.3, 0.01, 
			"Clouds layer should have scroll speed 0.3")
	
	var trees_layer = background.get_node_or_null("TreesLayer")
	if trees_layer:
		assert_almost_eq(trees_layer.motion_scale.x, 0.5, 0.01, 
			"Trees layer should have scroll speed 0.5")

func test_scene_metadata_configured():
	assert_not_null(scene, "Scene should exist")
	
	# Check scene metadata
	assert_eq(scene.get_meta("level_name", ""), "Dunia 2", 
		"Scene should have level_name metadata")
	assert_eq(scene.get_meta("level_size", Vector2.ZERO), Vector2(5000, 2000), 
		"Scene should have correct level_size metadata")
	assert_eq(scene.get_meta("spawn_point", Vector2.ZERO), Vector2(100, 1750), 
		"Scene should have correct spawn_point metadata")
	assert_eq(scene.get_meta("exit_point", Vector2.ZERO), Vector2(4800, 1750), 
		"Scene should have correct exit_point metadata")
	assert_eq(scene.get_meta("required_keys", 0), 3, 
		"Scene should require 3 keys")
	assert_eq(scene.get_meta("total_enemies", 0), 5, 
		"Scene should have 5 total enemies")
	assert_eq(scene.get_meta("total_bonus_items", 0), 3, 
		"Scene should have 3 bonus items")
