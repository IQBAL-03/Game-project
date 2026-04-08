extends Node
## Helper script to build Dunia 2 level layout programmatically
## This script builds the three-path level layout according to design specifications

@onready var tile_map: TileMapLayer = $TileMap
@onready var hazards_group: Node2D = $Hazards

func _ready():
	build_level_layout()
	setup_spike_damage()

func build_level_layout():
	if not tile_map:
		push_error("TileMap not found!")
		return
	
	# Clear existing tiles
	tile_map.clear()
	
	# Build the three paths according to design specifications
	build_path_a_bottom_route()
	build_path_b_middle_route()
	build_path_c_top_route()
	
	print("Dunia 2 level layout built successfully!")

## Path A (Easy - Bottom Route)
## y = 1600-1800, length 5000 pixels, low difficulty
func build_path_a_bottom_route():
	var tile_y_ground = 56  # y = 1800 / 32 = 56
	var tile_y_low = 50     # y = 1600 / 32 = 50
	
	# Starting platform (spawn area) - safe zone
	# x = 0-320 pixels
	for x in range(0, 10):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Platform 1: x = 320-640
	for x in range(10, 20):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Small gap (160px) - single jump
	
	# Platform 2: x = 800-1120 (includes enemy position at 800)
	for x in range(25, 35):
		tile_map.set_cell(Vector2i(x, tile_y_low), 0, Vector2i(1, 0))
	
	# Medium gap (200px) - running jump
	
	# Platform 3: x = 1320-1800 (includes spike group at 1200)
	for x in range(41, 56):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Small gap (160px)
	
	# Platform 4: x = 1960-2400
	for x in range(61, 75):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Path junction area - connects to Path B
	# Platform 5: x = 2560-3200
	for x in range(80, 100):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Medium gap (320px)
	
	# Platform 6: x = 3520-4160
	for x in range(110, 130):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))
	
	# Small gap (160px)
	
	# Final platform leading to exit: x = 4320-4960
	for x in range(135, 155):
		tile_map.set_cell(Vector2i(x, tile_y_ground), 0, Vector2i(1, 0))

## Path B (Medium - Middle Route)
## y = 1200-1400, length 4500 pixels, medium difficulty
func build_path_b_middle_route():
	var tile_y_mid_low = 43   # y = 1400 / 32 = 43.75 ≈ 44
	var tile_y_mid_high = 37  # y = 1200 / 32 = 37.5 ≈ 38
	
	# Access platform from spawn area
	# Platform 1: x = 480-800, y = 1400
	for x in range(15, 25):
		tile_map.set_cell(Vector2i(x, tile_y_mid_low), 0, Vector2i(2, 0))
	
	# Medium gap (250px)
	
	# Platform 2: x = 1050-1600 (includes enemy at 1500 and key at 1600)
	for x in range(33, 50):
		tile_map.set_cell(Vector2i(x, tile_y_mid_low), 0, Vector2i(2, 0))
	
	# Large gap (350px) - requires running jump
	
	# Platform 3: x = 1950-2450 (includes moving platform area and enemy at 2200)
	for x in range(61, 77):
		tile_map.set_cell(Vector2i(x, tile_y_mid_low), 0, Vector2i(2, 0))
	
	# Moving platform gap (handled by MovingPlatform1)
	
	# Platform 4: x = 2600-3200
	for x in range(81, 100):
		tile_map.set_cell(Vector2i(x, tile_y_mid_high), 0, Vector2i(2, 0))
	
	# Large gap (400px) - requires double jump or moving platform
	
	# Platform 5: x = 3600-4200 (includes spike group at 4000)
	for x in range(113, 131):
		tile_map.set_cell(Vector2i(x, tile_y_mid_low), 0, Vector2i(2, 0))
	
	# Connects to final area
	# Platform 6: x = 4400-4800
	for x in range(138, 150):
		tile_map.set_cell(Vector2i(x, tile_y_mid_low), 0, Vector2i(2, 0))

## Path C (Hard - Top Route)
## y = 600-800, length 4000 pixels (shortcut), high difficulty
func build_path_c_top_route():
	var tile_y_high = 25      # y = 800 / 32 = 25
	var tile_y_top = 18       # y = 600 / 32 = 18.75 ≈ 19
	var tile_y_secret = 12    # y = 400 / 32 = 12.5 ≈ 13 (for secret area)
	
	# Access from Path B via climbing or moving platform
	# Platform 1: x = 1600-2000, y = 800
	for x in range(50, 62):
		tile_map.set_cell(Vector2i(x, tile_y_high), 0, Vector2i(3, 0))
	
	# Large gap (500px) - requires double jump
	
	# Platform 2: x = 2500-2800, y = 800 (narrow platform)
	for x in range(78, 87):
		tile_map.set_cell(Vector2i(x, tile_y_high), 0, Vector2i(3, 0))
	
	# Secret area platform: x = 2700-2900, y = 400 (Key3 location)
	for x in range(84, 91):
		tile_map.set_cell(Vector2i(x, tile_y_secret), 0, Vector2i(4, 0))
	
	# Large gap (450px)
	
	# Platform 3: x = 3250-3600, y = 700 (includes enemies at 3000 and 3500, key at 3100)
	for x in range(94, 112):
		tile_map.set_cell(Vector2i(x, tile_y_high), 0, Vector2i(3, 0))
	
	# Moving platform area (MovingPlatform2 provides vertical access)
	
	# Platform 4: x = 3800-4200, y = 600 (bonus item at 3600)
	for x in range(112, 131):
		tile_map.set_cell(Vector2i(x, tile_y_top), 0, Vector2i(3, 0))
	
	# Descent to final area - connects back to Path B
	# Platform 5: x = 4300-4600, y = 800
	for x in range(134, 144):
		tile_map.set_cell(Vector2i(x, tile_y_high), 0, Vector2i(3, 0))

## Setup spike damage functionality
## Attaches spike script to all spike groups to enable damage dealing
func setup_spike_damage():
	if not hazards_group:
		push_warning("Hazards group not found, spike damage not configured")
		return
	
	# Load the spike script
	var spike_script = load("res://scripts/spike.gd")
	if not spike_script:
		push_error("Spike script not found at res://scripts/spike.gd")
		return
	
	# Attach script to all spike groups
	for child in hazards_group.get_children():
		if child.name.begins_with("SpikeGroup") and child is Area2D:
			# Only attach if script not already attached
			if child.get_script() == null:
				child.set_script(spike_script)
				print("Attached spike script to: ", child.name)
	
	print("Spike damage setup complete!")
