# Dunia 2 Level - Checkpoint 8 Manual Test Guide

## Objective
Verify that hazards (spikes, moving platforms) and enemy interactions work correctly in Dunia 2 level.

## Prerequisites
- Godot Engine 4.6.1 installed
- Project opened in Godot Editor
- Dunia 2 scene: `scenes/dunia_2.tscn`

## Test Procedures

### Test 1: Spike Damage Verification

**Objective:** Ensure spikes deal damage correctly to the player

**Steps:**
1. Open `scenes/dunia_2.tscn` in Godot Editor
2. Press F5 or click Play to run the scene
3. Move the player character to the right until you reach the first spike group (around x=1200)
4. Walk into the spikes

**Expected Results:**
- ✅ Player takes damage when touching spikes
- ✅ Player health decreases (visible in health bar if implemented)
- ✅ Player plays hurt animation
- ✅ Spikes are clearly visible and distinguishable from platforms

**Test Locations:**
- SpikeGroup1: Position (1200, 1760) - Ground level, 5 spikes horizontal
- SpikeGroup2: Position (1800, 1360) - Ceiling spikes, 3 spikes
- SpikeGroup3: Position (2500, 1760) - Ground level, 7 spikes with gap
- SpikeGroup4: Position (3200, 760) - High platform, 4 spikes
- SpikeGroup5: Position (4000, 1360) - Mid level, 5 spikes

**Pass Criteria:**
- [ ] Player takes damage from all spike groups
- [ ] Damage is consistent (1 damage per touch)
- [ ] No crashes or errors when colliding with spikes

---

### Test 2: Moving Platform Movement

**Objective:** Ensure moving platforms move smoothly and predictably

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to MovingPlatform1 location (around x=2000, y=1400)
3. Observe the platform movement
4. Jump onto the moving platform
5. Ride the platform from start to end position
6. Repeat for MovingPlatform2 (around x=3400, y=1000)

**Expected Results:**
- ✅ MovingPlatform1 moves horizontally between (2000, 1400) and (2400, 1400)
- ✅ MovingPlatform2 moves vertically between (3400, 1000) and (3400, 600)
- ✅ Movement is smooth and continuous
- ✅ Platform speed is appropriate (100 px/s for Platform1, 80 px/s for Platform2)
- ✅ Player can stand on moving platform without falling through
- ✅ Player moves with the platform (no sliding off)

**Pass Criteria:**
- [ ] Both platforms move in correct directions (horizontal/vertical)
- [ ] Movement is smooth without stuttering
- [ ] Player can ride platforms safely
- [ ] Platforms return to start position and loop continuously

---

### Test 3: Enemy Detection System

**Objective:** Ensure enemies detect and attack the player

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to PredatorPlant1 location (x=800, y=1600)
3. Approach the enemy from the right side
4. Observe enemy behavior
5. Move away from the enemy
6. Approach from the left side
7. Repeat for other enemies

**Expected Results:**
- ✅ Enemy plays idle animation when player is far away
- ✅ Enemy detects player when player enters detection range
- ✅ Enemy plays attack animation when player is nearby
- ✅ Enemy faces the correct direction (toward player)
- ✅ Enemy returns to idle when player moves away

**Test Locations:**
- PredatorPlant1: (800, 1600) - Path A guard
- PredatorPlant2: (1500, 1300) - Path B with spike nearby
- PredatorPlant3: (2200, 1300) - Path B timing challenge
- PredatorPlant4: (3000, 700) - Path C narrow platform
- PredatorPlant5: (3500, 700) - Path C double enemy

**Pass Criteria:**
- [ ] All 5 enemies detect player correctly
- [ ] Enemies attack when player is in range
- [ ] Enemies face correct direction
- [ ] No errors in console related to enemy AI

---

### Test 4: Enemy Damage to Player

**Objective:** Ensure enemies can deal damage to the player

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to any enemy location
3. Let the enemy attack the player (don't attack back)
4. Observe player health

**Expected Results:**
- ✅ Player takes damage when hit by enemy attack
- ✅ Player health decreases
- ✅ Player plays hurt animation
- ✅ Damage is consistent across all enemies

**Pass Criteria:**
- [ ] Player takes damage from enemy attacks
- [ ] Damage amount is appropriate (1 damage per hit)
- [ ] Player can die if health reaches 0

---

### Test 5: Player Can Defeat Enemies

**Objective:** Ensure player can attack and defeat enemies

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to PredatorPlant1
3. Attack the enemy using left mouse click
4. Continue attacking until enemy is defeated
5. Observe enemy death behavior

**Expected Results:**
- ✅ Player attack animation plays
- ✅ Enemy takes damage from player attacks
- ✅ Enemy plays death animation when defeated
- ✅ Enemy is removed from scene after death
- ✅ No errors occur during combat

**Pass Criteria:**
- [ ] Player can attack enemies
- [ ] Enemies can be defeated
- [ ] Death animation plays correctly
- [ ] Defeated enemies are removed from scene

---

### Test 6: Hazard and Enemy Combination

**Objective:** Verify strategic placement of hazards near enemies

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to PredatorPlant2 location (1500, 1300)
3. Observe nearby SpikeGroup2 at (1800, 1360)
4. Attempt to fight the enemy while avoiding spikes
5. Test if the combination creates a challenging scenario

**Expected Results:**
- ✅ Enemy and spike are close enough to create challenge
- ✅ Player has room to maneuver
- ✅ Both hazard and enemy function correctly together
- ✅ No collision or interaction bugs between enemy and spikes

**Pass Criteria:**
- [ ] Enemy and hazard combination works as intended
- [ ] Player can navigate the challenge
- [ ] No bugs or glitches in combined scenario

---

### Test 7: Moving Platform and Enemy Combination

**Objective:** Verify areas with both moving platforms and enemies

**Steps:**
1. Run the Dunia 2 scene (F5)
2. Navigate to the area around MovingPlatform2 (3400, 1000)
3. Look for nearby enemies (PredatorPlant4 at 3000, 700)
4. Attempt to use the moving platform while dealing with enemies

**Expected Results:**
- ✅ Moving platform and enemy both function correctly
- ✅ Player can fight enemy while on or near moving platform
- ✅ No collision issues between platform and enemy
- ✅ Challenge is fair and completable

**Pass Criteria:**
- [ ] Moving platform works near enemies
- [ ] Combat is possible on/near moving platforms
- [ ] No technical issues in combined scenario

---

## Overall Verification Checklist

### Spikes (Requirement 3.3)
- [ ] All 5 spike groups exist and are positioned correctly
- [ ] Spikes deal damage to player on contact
- [ ] Spike collision detection works reliably
- [ ] Spikes are visually distinct and clear

### Moving Platforms (Requirement 3.4)
- [ ] Both moving platforms exist and are positioned correctly
- [ ] MovingPlatform1 moves horizontally smoothly
- [ ] MovingPlatform2 moves vertically smoothly
- [ ] Platforms are predictable and fair
- [ ] Player can ride platforms without issues

### Enemies (Requirement 2.1, 2.2)
- [ ] All 5 PredatorPlant enemies exist
- [ ] Enemies are positioned strategically
- [ ] Enemies detect player correctly
- [ ] Enemies attack player when in range
- [ ] Enemies can be defeated by player

### Integration
- [ ] Hazards and enemies work together correctly
- [ ] No crashes or errors during gameplay
- [ ] Performance is acceptable
- [ ] All interactions feel fair and challenging

---

## Known Issues / Notes

### Issue 1: Spike Script Attachment
**Status:** Fixed in `dunia_2_level_builder.gd`

The spike groups in the scene file don't have scripts attached by default. The level builder script now automatically attaches the spike damage script (`scripts/spike.gd`) to all spike groups at runtime.

**Verification:** Check console output for "Attached spike script to: SpikeGroup[N]" messages when scene loads.

---

## Test Results

**Date:** _________________

**Tester:** _________________

**Overall Status:** [ ] PASS [ ] FAIL [ ] PARTIAL

**Notes:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Issues Found:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

**Recommendations:**
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

---

## Sign-off

**Tested by:** _________________

**Date:** _________________

**Approved:** [ ] YES [ ] NO [ ] NEEDS REVISION

