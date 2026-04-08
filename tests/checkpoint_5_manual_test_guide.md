# Checkpoint 5 - Manual Testing Guide

## How to Test in Godot Editor

Since automated testing requires GUT framework installation, please follow these manual verification steps in the Godot editor:

---

## Test 1: Scene Loads Without Errors

### Steps:
1. Open Godot 4.6.1
2. Open the project
3. In the FileSystem panel, navigate to `res://scenes/dunia_2.tscn`
4. Double-click to open the scene

### Expected Results:
- ✅ Scene opens without any error messages in the Output panel
- ✅ No "Missing Resource" or "Script Error" warnings
- ✅ Scene tree shows all nodes properly

### What to Look For:
- Check the Output panel (bottom) for any red error messages
- Verify the Scene tree (left) shows the complete hierarchy
- Look for any yellow warning icons on nodes

---

## Test 2: Player Spawns at Correct Position

### Steps:
1. With `dunia_2.tscn` open, locate the Player node in the Scene tree
2. Click on the Player node
3. Look at the Inspector panel (right side)
4. Find the "Transform" section and check the "Position" property

### Expected Results:
- ✅ Position X: 100
- ✅ Position Y: 1750

### Visual Verification:
1. Look at the 2D viewport (center)
2. The player should be visible near the left side of the screen
3. The player should be standing on or near the ground platform

### Alternative Method:
1. Press F6 to run the current scene
2. The player should appear at the spawn point
3. Press Escape to stop the scene

---

## Test 3: Camera Follows Player with Proper Bounds

### Steps:
1. In the Scene tree, expand the Player node
2. Click on the Camera2D child node
3. In the Inspector panel, scroll to the "Limit" section

### Expected Results:
- ✅ Limit Left: 0
- ✅ Limit Top: 0
- ✅ Limit Right: 5000
- ✅ Limit Bottom: 2000

### Smoothing Verification:
In the Inspector, find the "Position Smoothing" section:
- ✅ Position Smoothing Enabled: ON (checked)
- ✅ Position Smoothing Speed: 5.0

### Runtime Test:
1. Press F6 to run the scene
2. Use arrow keys or WASD to move the player
3. Observe the camera:
   - ✅ Camera should smoothly follow the player
   - ✅ Camera should not show areas beyond the level bounds
   - ✅ Movement should feel smooth, not jerky

4. Try moving to the edges:
   - Move left: Camera should stop at x=0
   - Move right: Camera should stop at x=5000
   - Jump high: Camera should stop at y=0
   - Fall down: Camera should stop at y=2000

5. Press Escape to stop the scene

---

## Additional Verification Checks

### Check 4: Scene Metadata

1. Click on the root "Dunia_2" node in the Scene tree
2. In the Inspector, scroll to the "Metadata" section at the bottom
3. Verify the following metadata exists:
   - level_name: "Dunia 2"
   - level_size: (5000, 2000)
   - spawn_point: (100, 1750)
   - exit_point: (4800, 1750)
   - required_keys: 3
   - total_enemies: 5
   - total_bonus_items: 3

### Check 5: Node Structure

Expand the Scene tree and verify these nodes exist:
- ✅ Dunia_2 (root)
  - ✅ TileMap
  - ✅ Background
    - ✅ SkyLayer
    - ✅ CloudsLayer
    - ✅ TreesLayer
  - ✅ Player
    - ✅ AnimatedSprite2D
    - ✅ climb
    - ✅ Badan (CollisionShape2D)
    - ✅ AttackBox
    - ✅ HealthComponent
    - ✅ Camera2D
  - ✅ Enemies (empty for now)
  - ✅ Hazards (empty for now)
  - ✅ MovingPlatforms (empty for now)
  - ✅ Collectibles (empty for now)
  - ✅ Chests (empty for now)
  - ✅ Decorations
    - ✅ Stalactites (8 children)
    - ✅ FlyingStones (5 children)
    - ✅ Vegetation (12 children)
  - ✅ ExitPortal

### Check 6: Visual Elements

1. Look at the 2D viewport
2. You should see:
   - ✅ Background layers (sky, clouds, trees)
   - ✅ Platform tiles (swamp theme)
   - ✅ Player character
   - ✅ Decorative elements (stalactites, stones, bushes)

---

## Troubleshooting

### If scene doesn't load:
- Check that all resource paths are correct
- Verify swamp tileset is imported properly
- Check Output panel for specific error messages

### If player is not visible:
- Check Player node position in Inspector
- Verify AnimatedSprite2D has frames assigned
- Check if player is behind background layers

### If camera doesn't follow:
- Verify Camera2D is child of Player node
- Check that Camera2D is set as "Current" (should be automatic)
- Verify position_smoothing_enabled is checked

### If camera shows areas outside bounds:
- Double-check limit values in Camera2D Inspector
- Ensure limits are enabled (they should be by default)

---

## Success Criteria

All three main objectives must pass:
1. ✅ Scene loads without errors in Godot editor
2. ✅ Player spawns at position (100, 1750)
3. ✅ Camera follows player with bounds (0, 0) to (5000, 2000)

If all checks pass, Checkpoint 5 is complete! ✅

---

## Next Steps After Checkpoint 5

Once verified, proceed to:
- Task 6: Place enemies with strategic positioning
- Task 7: Add hazards and obstacles
- Task 9: Implement collectibles system
- Task 10: Setup exit portal and level completion

---

## Questions or Issues?

If you encounter any problems or have questions about the scene configuration, please let me know and I can help troubleshoot or make adjustments.
