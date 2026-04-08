# Checkpoint 11: Full Gameplay Loop Test Guide

## Test Objective
Verify the complete gameplay flow from spawn to level completion, ensuring all systems work together correctly.

## Test Date
Generated: 2024

## Prerequisites
- Dunia 2 scene (scenes/dunia_2.tscn) must be loaded
- All previous tasks (1-10) should be completed

## Test Scenarios

### 1. Player Spawn Test
**Objective:** Verify player spawns correctly at the designated spawn point

**Steps:**
1. Load dunia_2.tscn scene
2. Run the scene
3. Observe player position

**Expected Results:**
- Player spawns at position (100, 1750)
- Player is visible and animated (idle animation playing)
- Camera is centered on player
- No errors in console

**Status:** [ ] Pass [ ] Fail

---

### 2. Key Collection Test
**Objective:** Verify all 3 keys can be collected

**Steps:**
1. Navigate to Key1 location (1600, 1250) - Path B, medium difficulty
2. Collect Key1 by touching it
3. Navigate to Key2 location (3100, 650) - Path C, high risk area
4. Collect Key2 by touching it
5. Navigate to Key3 location (2800, 400) - Secret area, very hard
6. Collect Key3 by touching it

**Expected Results:**
- Each key plays collection animation when touched
- Keys follow player after collection
- Player can carry all 3 keys simultaneously
- Keys are trackable (visible following player)

**Status:** [ ] Pass [ ] Fail

---

### 3. Bonus Item Collection Test
**Objective:** Verify all 3 bonus items can be collected and tracked

**Steps:**
1. Navigate to BonusItem1 (1000, 1550) - Path A, easy
2. Collect BonusItem1
3. Navigate to BonusItem2 (2300, 1150) - Path B, moving platform timing
4. Collect BonusItem2
5. Navigate to BonusItem3 (3600, 550) - Path C, secret area
6. Collect BonusItem3

**Expected Results:**
- Each bonus item disappears when collected
- Bonus items are trackable (count increases)
- No errors when collecting

**Status:** [ ] Pass [ ] Fail

---

### 4. Final Chest Opening Test
**Objective:** Verify chest requires all 3 keys and opens correctly

**Steps:**
1. Navigate to FinalChest location (4600, 1750) with 0 keys
2. Attempt to open chest
3. Collect all 3 keys
4. Return to FinalChest
5. Open chest with all 3 keys

**Expected Results:**
- With 0 keys: Chest shows message "Need 3 more key(s) to open this chest"
- With 1-2 keys: Chest shows appropriate message
- With 3 keys: Chest opens with animation
- All 3 keys are consumed/removed after opening
- Console shows chest opened successfully

**Status:** [ ] Pass [ ] Fail

---

### 5. Exit Portal Activation Test
**Objective:** Verify exit portal only activates after chest is opened

**Steps:**
1. Navigate to ExitPortal (4800, 1750) before opening chest
2. Attempt to enter portal
3. Open the final chest
4. Return to ExitPortal
5. Enter the portal

**Expected Results:**
- Before chest opened: Portal is dimmed/inactive, shows message "Complete the objective first"
- After chest opened: Portal becomes active (green glow, particles)
- Entering active portal triggers level completion
- Console shows "Level Complete!"

**Status:** [ ] Pass [ ] Fail

---

### 6. Complete Gameplay Flow Test
**Objective:** Verify entire gameplay loop from start to finish

**Steps:**
1. Start scene at spawn point
2. Collect all 3 keys (in any order)
3. Collect all 3 bonus items (optional)
4. Navigate to final chest
5. Open chest with all keys
6. Navigate to exit portal
7. Complete level

**Expected Results:**
- Player can complete entire flow without errors
- All collectibles are trackable throughout
- Chest opens only with all keys
- Exit portal activates only after chest opens
- Level completion triggers correctly
- No console errors during entire playthrough

**Status:** [ ] Pass [ ] Fail

---

### 7. Hazard Interaction Test
**Objective:** Verify hazards work during gameplay loop

**Steps:**
1. Touch spike groups during navigation
2. Interact with moving platforms
3. Encounter enemies during key collection

**Expected Results:**
- Spikes deal damage to player
- Moving platforms move smoothly and can be used for navigation
- Enemies detect and attack player
- Player can defeat enemies
- Hazards don't prevent level completion

**Status:** [ ] Pass [ ] Fail

---

### 8. Camera Bounds Test
**Objective:** Verify camera follows player correctly throughout level

**Steps:**
1. Navigate through entire level from spawn to exit
2. Move to extreme positions (top, bottom, left, right)
3. Observe camera behavior

**Expected Results:**
- Camera smoothly follows player
- Camera stays within bounds (0, 0) to (5000, 2000)
- No areas outside level bounds are visible
- Camera provides good visibility at all positions

**Status:** [ ] Pass [ ] Fail

---

## Test Summary

**Total Tests:** 8
**Passed:** ___
**Failed:** ___
**Pass Rate:** ___%

## Issues Found
(List any issues discovered during testing)

1. 
2. 
3. 

## Notes
(Additional observations or comments)

## Tester Sign-off
- Tester Name: _______________
- Date: _______________
- Signature: _______________
