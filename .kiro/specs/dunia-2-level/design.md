# Design Document: Dunia 2 Level

## Overview

Dunia 2 adalah level kedua dalam game platformer action 2D yang dirancang untuk memberikan tantangan signifikan lebih tinggi dari Dunia 1. Level ini memanfaatkan semua mekanik yang sudah ada (movement, combat, platforming, puzzle) dan mengkombinasikannya dalam layout yang lebih kompleks dengan enemy placement strategis, obstacle berbahaya, dan puzzle multi-key.

Design ini fokus pada reusability - menggunakan semua existing scripts dan assets tanpa modifikasi, hanya mengatur ulang layout, placement, dan konfigurasi untuk menciptakan experience yang fresh dan challenging.

## Architecture

### Scene Structure

```
dunia_2.tscn (root)
├── TileMap (platforms dan environment)
├── Background (parallax layers)
│   ├── Sky
│   ├── Clouds
│   └── DistantTrees
├── Player (spawn point)
├── Camera2D (dengan limits)
├── Enemies
│   ├── PredatorPlant1
│   ├── PredatorPlant2
│   ├── PredatorPlant3
│   ├── PredatorPlant4
│   └── PredatorPlant5
├── Hazards
│   ├── SpikeGroup1
│   ├── SpikeGroup2
│   ├── SpikeGroup3
│   ├── SpikeGroup4
│   └── SpikeGroup5
├── MovingPlatforms
│   ├── MovingPlatform1 (horizontal)
│   └── MovingPlatform2 (vertical)
├── Collectibles
│   ├── Key1
│   ├── Key2
│   ├── Key3
│   ├── BonusItem1
│   ├── BonusItem2
│   └── BonusItem3
├── Chests
│   └── FinalChest
└── ExitPortal
```

### Coordinate System dan Scale

- Level size: 5000x2000 pixels (3x lebih panjang dari Dunia 1)
- Tile size: 32x32 pixels
- Player spawn: (100, 1800)
- Exit portal: (4800, 1800)
- Camera bounds: (0, 0) to (5000, 2000)

### Collision Layers

Menggunakan collision layers yang sudah ada:
- Layer 1: Platforms dan ground
- Layer 2: Player
- Layer 3: Enemies
- Layer 4: Hazards (spikes)
- Layer 5: Collectibles
- Layer 6: Moving platforms

## Components and Interfaces

### 1. Level Layout Design

**Three Path System:**

Path A (Easy - Bottom Route):
- Panjang: 5000 pixels
- Ketinggian: y = 1600-1800
- Obstacles: 2 spike groups, 1 enemy
- Reward: 1 bonus item
- Risk: Low

Path B (Medium - Middle Route):
- Panjang: 4500 pixels
- Ketinggian: y = 1200-1400
- Obstacles: 3 spike groups, 2 enemies, 1 moving platform
- Reward: 2 bonus items, 1 key
- Risk: Medium

Path C (Hard - Top Route):
- Panjang: 4000 pixels (shortcut)
- Ketinggian: y = 600-800
- Obstacles: 2 spike groups, 2 enemies, 2 moving platforms
- Reward: 2 keys, 1 bonus item, shortcut to exit
- Risk: High

**Platform Heights:**
- Ground level: y = 1800
- Low platforms: y = 1600
- Mid platforms: y = 1200-1400
- High platforms: y = 800-1000
- Top platforms: y = 400-600

**Gap Widths:**
- Small gap: 150-200 pixels (single jump)
- Medium gap: 250-350 pixels (running jump)
- Large gap: 400-500 pixels (double jump required)

### 2. Enemy Placement Strategy

**PredatorPlant1:**
- Position: (800, 1600)
- Context: Path A, di platform sempit setelah first gap
- Strategy: Guard easy path entrance

**PredatorPlant2:**
- Position: (1500, 1300)
- Context: Path B, di platform dekat spike group
- Strategy: Kombinasi enemy + hazard

**PredatorPlant3:**
- Position: (2200, 1300)
- Context: Path B, di platform sebelum moving platform
- Strategy: Timing challenge

**PredatorPlant4:**
- Position: (3000, 700)
- Context: Path C, di platform sempit dengan gap besar di kedua sisi
- Strategy: High risk combat

**PredatorPlant5:**
- Position: (3500, 700)
- Context: Path C, berdekatan dengan PredatorPlant4
- Strategy: Double enemy challenge

### 3. Hazard Placement

**SpikeGroup1:**
- Position: (1200, 1760)
- Context: Path A, di ground level
- Pattern: 5 spikes horizontal

**SpikeGroup2:**
- Position: (1800, 1360)
- Context: Path B, di bawah platform
- Pattern: 3 spikes di ceiling

**SpikeGroup3:**
- Position: (2500, 1760)
- Context: Path A/B junction
- Pattern: 7 spikes horizontal dengan gap di tengah

**SpikeGroup4:**
- Position: (3200, 760)
- Context: Path C, di platform sempit
- Pattern: 4 spikes di kedua sisi platform

**SpikeGroup5:**
- Position: (4000, 1360)
- Context: Path B, sebelum final area
- Pattern: Spike pit dengan moving platform di atasnya

### 4. Moving Platform Configuration

**MovingPlatform1 (Horizontal):**
- Start position: (2000, 1400)
- End position: (2400, 1400)
- Speed: 100 pixels/second
- Pattern: Linear back-and-forth
- Context: Path B, crossing medium gap

**MovingPlatform2 (Vertical):**
- Start position: (3400, 1000)
- End position: (3400, 600)
- Speed: 80 pixels/second
- Pattern: Linear back-and-forth
- Context: Path C, elevator to top route

### 5. Key and Chest System

**Key1:**
- Position: (1600, 1250)
- Context: Path B, di platform setelah PredatorPlant2
- Difficulty: Medium (requires defeating enemy)

**Key2:**
- Position: (3100, 650)
- Context: Path C, di platform sempit dengan PredatorPlant4
- Difficulty: Hard (high risk area)

**Key3:**
- Position: (2800, 400)
- Context: Secret area di Path C, requires precise double jump
- Difficulty: Very Hard (hidden location)

**FinalChest:**
- Position: (4600, 1750)
- Context: Near exit portal
- Requirement: All 3 keys collected
- Content: Victory item / level complete trigger

### 6. Bonus Items

**BonusItem1:**
- Position: (1000, 1550)
- Context: Path A, easy to reach

**BonusItem2:**
- Position: (2300, 1150)
- Context: Path B, requires moving platform timing

**BonusItem3:**
- Position: (3600, 550)
- Context: Path C, secret area above main path

### 7. Spawn and Exit Points

**Spawn_Point:**
- Position: (100, 1750)
- Safe zone: 200 pixel radius tanpa enemy/hazard
- Visual marker: Glowing platform atau spawn effect

**Exit_Portal:**
- Position: (4800, 1750)
- Activation: Requires FinalChest opened
- Visual: Portal animation atau door
- Trigger area: 100 pixel radius

### 8. Camera Configuration

```gdscript
# Camera2D settings (existing script)
limit_left = 0
limit_top = 0
limit_right = 5000
limit_bottom = 2000
smoothing_enabled = true
smoothing_speed = 5.0
position_smoothing_enabled = true
```

### 9. Visual Theme Implementation

**Background Layers (Parallax):**
- Layer 1 (Sky): Dark swamp sky, scroll speed 0.1
- Layer 2 (Clouds): Fog/mist, scroll speed 0.3
- Layer 3 (Distant Trees): Swamp trees silhouette, scroll speed 0.5

**Environment Details:**
- Stalactites: 8-10 pieces di ceiling area
- Flying stones: 5-7 pieces floating
- Swamp vegetation: Scattered throughout
- Water puddles: Ground level decoration

**Color Palette:**
- Background: Dark green/brown (#2a3a2e)
- Platforms: Mossy stone (#4a5a4e)
- Accent: Toxic green (#6fb86f)

## Data Models

### Level Configuration

```gdscript
# Level metadata (dapat disimpan di scene properties atau separate config)
class_name Dunia2Config

const LEVEL_NAME = "Dunia 2"
const LEVEL_SIZE = Vector2(5000, 2000)
const SPAWN_POINT = Vector2(100, 1750)
const EXIT_POINT = Vector2(4800, 1750)
const REQUIRED_KEYS = 3
const TOTAL_ENEMIES = 5
const TOTAL_BONUS_ITEMS = 3
```

### Collectible State Tracking

```gdscript
# Global state (existing system)
var keys_collected = 0
var bonus_items_collected = 0
var enemies_defeated = 0
var deaths = 0
var level_complete = false
```

### Moving Platform Data

```gdscript
# MovingPlatform node properties (existing AnimatableBody2D)
@export var start_position: Vector2
@export var end_position: Vector2
@export var speed: float = 100.0
@export var movement_type: String = "linear"  # linear, smooth
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system - essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*


### Property 1: Spike Collision Damage

*For any* collision between Player and Spike, the Game_System should apply damage to the Player's health.

**Validates: Requirements 3.3**

### Property 2: Key-Chest System Integrity

*For any* game state, the final Chest should only be openable when keys_collected equals REQUIRED_KEYS, and each Key collection should increment keys_collected by exactly 1.

**Validates: Requirements 4.3, 4.4**

### Property 3: Level Completion Flow

*For any* interaction with Exit_Portal, the level should only be marked as complete when the final Chest has been opened AND the Player collides with the Exit_Portal trigger area.

**Validates: Requirements 6.3, 6.5**

### Property 4: Player Respawn on Death

*For any* Player death event, the Player's position should be reset to the Spawn_Point coordinates.

**Validates: Requirements 6.4**

### Property 5: Camera Bounds Clamping

*For any* Player position, the Camera position should be clamped within Camera_Bounds such that no area outside the bounds is visible.

**Validates: Requirements 7.3**

### Property 6: Enemy Defeat Notification

*For any* game state where enemies_defeated equals TOTAL_ENEMIES, the Game_System should trigger the optional challenge complete notification exactly once.

**Validates: Requirements 2.5, 9.3**

### Property 7: Bonus Collection Achievement

*For any* game state where bonus_items_collected equals TOTAL_BONUS_ITEMS, the Game_System should trigger the achievement notification exactly once.

**Validates: Requirements 9.2**

### Property 8: Perfect Clear Bonus

*For any* level completion event, if deaths equals 0, the Game_System should award the perfect clear bonus.

**Validates: Requirements 9.5**

## Error Handling

### Player Death Scenarios

**Fall Death:**
- Trigger: Player y-position > level bottom bound (y > 2000)
- Action: Trigger death sequence, respawn at Spawn_Point
- State: Increment deaths counter

**Spike Death:**
- Trigger: Player health <= 0 after spike damage
- Action: Trigger death sequence, respawn at Spawn_Point
- State: Increment deaths counter, reset health

**Enemy Death:**
- Trigger: Player health <= 0 after enemy attack
- Action: Trigger death sequence, respawn at Spawn_Point
- State: Increment deaths counter, reset health

### Invalid Interactions

**Chest Without Keys:**
- Trigger: Player attempts to open chest with keys_collected < REQUIRED_KEYS
- Action: Display "Need X more keys" message
- State: No change

**Exit Without Chest:**
- Trigger: Player attempts to use exit portal before opening chest
- Action: Display "Complete the objective first" message
- State: No change

### Scene Loading Errors

**Missing Node References:**
- Detection: Check for null references on _ready()
- Action: Log error with node name, disable affected feature
- Fallback: Continue with degraded functionality

**Script Attachment Errors:**
- Detection: Verify all required scripts attached
- Action: Log error, attempt to continue
- Fallback: Use default behavior if possible

## Testing Strategy

### Dual Testing Approach

Testing untuk Dunia 2 Level akan menggunakan kombinasi unit tests dan property-based tests untuk memastikan comprehensive coverage:

**Unit Tests** akan fokus pada:
- Scene configuration verification (node counts, positions, configurations)
- Specific example scenarios (player reaches exit, collects specific key)
- Edge cases (player at exact boundary, zero keys collected)
- Integration points (scene loading, script attachments)

**Property-Based Tests** akan fokus pada:
- Universal game logic properties (collision damage, state management)
- Randomized input scenarios (various player positions, different collection orders)
- State invariants (key count never exceeds max, camera always within bounds)
- Comprehensive input coverage through randomization

### Property-Based Testing Configuration

Untuk Godot/GDScript, kita akan menggunakan **GUT (Godot Unit Test)** framework dengan custom property test helpers. Setiap property test akan:
- Run minimum **100 iterations** dengan randomized inputs
- Tag dengan comment format: `# Feature: dunia-2-level, Property N: [property text]`
- Generate random game states, player positions, dan interaction sequences
- Verify property holds untuk semua generated inputs

### Test Organization

```
tests/
├── unit/
│   ├── test_dunia_2_scene_config.gd
│   ├── test_dunia_2_collectibles.gd
│   └── test_dunia_2_integration.gd
└── property/
    ├── test_dunia_2_collision_properties.gd
    ├── test_dunia_2_state_properties.gd
    └── test_dunia_2_camera_properties.gd
```

### Example Test Structure

```gdscript
# Unit Test Example
func test_scene_has_correct_number_of_keys():
    var scene = load("res://scenes/dunia_2.tscn").instantiate()
    var keys = scene.get_node("Collectibles").get_children().filter(
        func(node): return node is Key
    )
    assert_eq(keys.size(), 3, "Should have exactly 3 keys")

# Property Test Example
# Feature: dunia-2-level, Property 1: Spike Collision Damage
func test_property_spike_collision_damage():
    for i in range(100):  # 100 iterations
        var player = create_test_player()
        var spike = create_test_spike()
        var initial_health = randf_range(10, 100)
        player.health = initial_health
        
        # Simulate collision
        spike.on_body_entered(player)
        
        # Property: damage should be applied
        assert_lt(player.health, initial_health, 
            "Spike collision should reduce player health")
```

### Coverage Goals

- **Scene Configuration**: 100% (all nodes, positions, configurations verified)
- **Game Logic Properties**: 100% (all 8 properties tested with 100+ iterations each)
- **Integration Points**: 100% (scene loading, script attachments, state management)
- **Edge Cases**: Key scenarios covered (boundaries, zero states, max states)

### Testing Workflow

1. **Scene Configuration Tests**: Verify level structure sesuai design
2. **Unit Tests**: Test specific scenarios dan edge cases
3. **Property Tests**: Verify universal properties dengan randomized inputs
4. **Integration Tests**: Test full gameplay flow dari spawn ke exit
5. **Manual Playtesting**: Verify feel, difficulty balance, visual quality

## Implementation Notes

### Reusing Existing Systems

Semua existing scripts akan di-reuse tanpa modifikasi:
- `player.gd`: Movement, combat, health system
- `predator_plant.gd`: Enemy AI, detection, attack
- `key.gd`: Collectible logic, state tracking
- `chest.gd`: Interaction logic, key requirement check
- `spike.gd`: Hazard collision, damage dealing
- `moving_platform.gd`: Platform movement logic

### Scene Setup Workflow

1. Create new scene `dunia_2.tscn`
2. Setup TileMap dengan swamp theme tiles
3. Place platforms sesuai three-path design
4. Add ParallaxBackground dengan 3 layers
5. Instance Player node di spawn point
6. Setup Camera2D dengan bounds
7. Instance 5 PredatorPlant nodes di strategic positions
8. Place 5 spike groups di hazardous locations
9. Add 2 moving platforms dengan different patterns
10. Place 3 keys di different difficulty areas
11. Place 1 final chest near exit
12. Add 3 bonus items di hard-to-reach areas
13. Place exit portal di end position
14. Add environment decorations (stalactites, stones, vegetation)
15. Configure collision layers untuk all objects
16. Test scene loading dan basic functionality

### Performance Considerations

- Level size 5000x2000 adalah manageable untuk 2D game
- TileMap akan di-optimize oleh Godot automatically
- ParallaxBackground layers minimal overhead
- 5 enemies adalah reasonable untuk performance
- Camera smoothing tidak significant impact
- Collision detection efficient dengan proper layers

### Accessibility Considerations

- Clear visual distinction antara platforms dan background
- Hazards (spikes) clearly visible dengan distinct color
- Enemies dengan clear silhouette dan animation
- Keys dan collectibles dengan glow atau highlight effect
- Exit portal dengan obvious visual marker
- Spawn point dengan safe zone indicator
