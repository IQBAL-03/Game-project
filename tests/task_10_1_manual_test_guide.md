# Manual Test Guide - Task 10.1: Exit Portal Configuration

## Overview
This guide helps verify that the ExitPortal in Dunia 2 Level is properly configured according to the design specifications.

## Test Prerequisites
- Godot 4.6.1 editor open
- dunia_2.tscn scene loaded

## Test Cases

### Test 1: Exit Portal Exists and Position
**Steps:**
1. Open `scenes/dunia_2.tscn` in Godot editor
2. In the Scene tree, locate the `ExitPortal` node at root level
3. Select the ExitPortal node
4. Check the Transform position in the Inspector

**Expected Results:**
- ✓ ExitPortal node exists in scene tree
- ✓ Position is (4800, 1750)
- ✓ Node type is Area2D

### Test 2: Exit Portal Components
**Steps:**
1. With ExitPortal selected, expand the node in Scene tree
2. Verify child nodes exist:
   - Sprite2D
   - CollisionShape2D
   - CPUParticles2D

**Expected Results:**
- ✓ Sprite2D exists with cave_entrance.png texture
- ✓ CollisionShape2D exists with CircleShape2D (radius 100)
- ✓ CPUParticles2D exists (initially not emitting)

### Test 3: Exit Portal Script Configuration
**Steps:**
1. Select ExitPortal node
2. In Inspector, check Script section
3. Verify script is attached: `res://scripts/exit_portal.gd`

**Expected Results:**
- ✓ Script is attached
- ✓ No script errors shown

### Test 4: Collision Layers
**Steps:**
1. Select ExitPortal node
2. In Inspector, expand Collision section
3. Check Layer and Mask settings

**Expected Results:**
- ✓ Collision Layer: 32 (Collectibles)
- ✓ Collision Mask: 2 (Player)

### Test 5: Visual Marker
**Steps:**
1. Run the scene (F6)
2. Navigate player to position (4800, 1750)
3. Observe the exit portal visual

**Expected Results:**
- ✓ Portal sprite is visible
- ✓ Portal appears dimmed/gray (inactive state)
- ✓ No particles emitting initially

### Test 6: Activation Requirement - Before Chest Opened
**Steps:**
1. Run the scene (F6)
2. Navigate player to exit portal WITHOUT collecting keys or opening chest
3. Move player into the portal trigger area (100 pixel radius)
4. Check console output

**Expected Results:**
- ✓ Portal remains inactive (dimmed)
- ✓ Console shows: "Complete the objective first - open the final chest!"
- ✓ Level does NOT complete

### Test 7: Activation Requirement - After Chest Opened
**Steps:**
1. Run the scene (F6)
2. Collect all 3 keys:
   - Key1 at (1600, 1250)
   - Key2 at (3100, 650)
   - Key3 at (2800, 400)
3. Open the final chest at (4600, 1750)
4. Navigate to exit portal at (4800, 1750)
5. Observe portal visual changes

**Expected Results:**
- ✓ After chest opens, portal activates
- ✓ Portal sprite changes to green glow (Color: 0.4, 1.0, 0.4)
- ✓ Particles start emitting (green particles)
- ✓ Console shows: "Exit portal activated!"

### Test 8: Level Completion
**Steps:**
1. Continue from Test 7 (chest opened, portal active)
2. Move player into portal trigger area
3. Check console output

**Expected Results:**
- ✓ Console shows: "Level Complete!"
- ✓ Player can interact with active portal

### Test 9: Trigger Area Size
**Steps:**
1. Open scene in editor
2. Select ExitPortal > CollisionShape2D
3. Enable "Visible Collision Shapes" in editor (Debug menu)
4. Verify the circle radius visually

**Expected Results:**
- ✓ Collision circle has 100 pixel radius
- ✓ Circle is centered on portal position

### Test 10: Integration with Final Chest
**Steps:**
1. Open `scripts/final_chest.gd`
2. Verify chest is in "final_chest" group
3. Verify chest has `is_opened()` method

**Expected Results:**
- ✓ Chest adds itself to "final_chest" group in _ready()
- ✓ Chest has `is_opened()` method that returns `sudah_terbuka`
- ✓ Exit portal can find and check chest status

## Summary Checklist

Configuration:
- [ ] ExitPortal at position (4800, 1750)
- [ ] Script attached: exit_portal.gd
- [ ] Sprite2D with cave_entrance texture
- [ ] CollisionShape2D with 100px radius
- [ ] CPUParticles2D for visual effect
- [ ] Collision layers: Layer 32, Mask 2

Functionality:
- [ ] Portal starts inactive (dimmed)
- [ ] Portal checks chest status continuously
- [ ] Portal activates when chest opens
- [ ] Active portal shows green glow
- [ ] Active portal emits particles
- [ ] Inactive portal blocks level completion
- [ ] Active portal allows level completion
- [ ] Trigger area is 100 pixel radius

## Notes
- The exit portal continuously checks the chest status in `_process()`
- Visual feedback (color and particles) clearly indicates active/inactive state
- The portal is positioned near the final chest (200 pixels away) for good level flow
- Level completion logic is a placeholder - can be extended for actual level transitions
