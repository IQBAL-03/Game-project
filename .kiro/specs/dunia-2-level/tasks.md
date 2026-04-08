# Implementation Plan: Dunia 2 Level

## Overview

Implementation plan ini akan membangun Dunia 2 Level secara incremental, dimulai dari scene setup, layout construction, entity placement, sampai testing dan polish. Setiap task dirancang untuk build on previous work dan menghasilkan testable progress di setiap step.

## Tasks

- [x] 1. Setup scene structure dan basic configuration
  - Create dunia_2.tscn scene file baru
  - Setup root node dan basic scene hierarchy
  - Configure scene properties (level name, metadata)
  - Setup collision layers configuration
  - _Requirements: 8.1, 8.3, 8.5_

- [ ] 2. Build TileMap dan platform layout
  - [x] 2.1 Create TileMap node dengan swamp theme tileset
    - Import dan configure swamp theme tiles
    - Setup TileMap collision shapes
    - _Requirements: 5.1, 8.3_
  
  - [x] 2.2 Build three-path level layout
    - Create Path A (bottom route) platforms
    - Create Path B (middle route) platforms
    - Create Path C (top route) platforms
    - Ensure proper platform heights dan gap widths sesuai design
    - _Requirements: 1.1, 1.2, 1.5_
  
  - [ ]* 2.3 Write unit tests untuk scene configuration
    - Test level size matches specification
    - Test platform counts dan positions
    - _Requirements: 1.1, 1.2, 1.5_

- [ ] 3. Setup background dan visual theme
  - [x] 3.1 Create ParallaxBackground dengan multiple layers
    - Add sky layer dengan dark swamp colors
    - Add clouds/mist layer
    - Add distant trees silhouette layer
    - Configure scroll speeds untuk each layer
    - _Requirements: 5.2, 5.5_
  
  - [x] 3.2 Add environment decorations
    - Place stalactites di ceiling areas (8-10 pieces)
    - Add flying stones (5-7 pieces)
    - Add swamp vegetation decorations
    - Add water puddles di ground level
    - _Requirements: 5.3_
  
  - [ ]* 3.3 Write unit tests untuk visual elements
    - Test ParallaxBackground exists dengan correct layers
    - Test minimum decoration counts
    - _Requirements: 5.3, 5.5_

- [ ] 4. Setup Player spawn dan Camera system
  - [x] 4.1 Instance Player node di spawn point
    - Add Player scene instance
    - Set position ke (100, 1750)
    - Verify player.gd script attached
    - Create safe zone area (200 pixel radius)
    - _Requirements: 6.1, 8.2_
  
  - [x] 4.2 Configure Camera2D dengan bounds
    - Add Camera2D node ke Player
    - Set camera limits (0, 0) to (5000, 2000)
    - Configure smoothing settings
    - _Requirements: 7.1, 7.4_
  
  - [ ]* 4.3 Write property test untuk camera bounds clamping
    - **Property 5: Camera Bounds Clamping**
    - **Validates: Requirements 7.3**
  
  - [ ]* 4.4 Write property test untuk player respawn
    - **Property 4: Player Respawn on Death**
    - **Validates: Requirements 6.4**

- [x] 5. Checkpoint - Test basic scene loading dan player spawn
  - Ensure scene loads tanpa errors
  - Ensure player spawns di correct position
  - Ensure camera follows player dengan proper bounds
  - Ask user if questions arise

- [ ] 6. Place enemies dengan strategic positioning
  - [x] 6.1 Instance 5 PredatorPlant nodes
    - Add PredatorPlant1 di (800, 1600) - Path A guard
    - Add PredatorPlant2 di (1500, 1300) - Path B dengan spike
    - Add PredatorPlant3 di (2200, 1300) - Path B timing challenge
    - Add PredatorPlant4 di (3000, 700) - Path C narrow platform
    - Add PredatorPlant5 di (3500, 700) - Path C double enemy
    - Verify predator_plant.gd script attached ke all instances
    - _Requirements: 2.1, 2.2, 2.4, 8.2_
  
  - [ ]* 6.2 Write unit tests untuk enemy placement
    - Test correct number of enemies (3-5)
    - Test minimal 2 enemies di strategic positions
    - Test minimal 1 area dengan 2 enemies berdekatan
    - _Requirements: 2.1, 2.2, 2.4_
  
  - [ ]* 6.3 Write property test untuk enemy defeat notification
    - **Property 6: Enemy Defeat Notification**
    - **Validates: Requirements 2.5, 9.3**

- [ ] 7. Add hazards dan obstacles
  - [x] 7.1 Place spike groups di hazardous locations
    - Add SpikeGroup1 di (1200, 1760) - Path A, 5 spikes horizontal
    - Add SpikeGroup2 di (1800, 1360) - Path B, 3 spikes ceiling
    - Add SpikeGroup3 di (2500, 1760) - Path junction, 7 spikes dengan gap
    - Add SpikeGroup4 di (3200, 760) - Path C, 4 spikes narrow platform
    - Add SpikeGroup5 di (4000, 1360) - Path B, spike pit
    - Configure collision layers untuk hazards
    - _Requirements: 3.1, 8.3_
  
  - [x] 7.2 Create dan place moving platforms
    - Create MovingPlatform1 (horizontal) di (2000, 1400) to (2400, 1400)
    - Create MovingPlatform2 (vertical) di (3400, 1000) to (3400, 600)
    - Configure movement speeds dan patterns
    - Verify moving_platform.gd script attached
    - _Requirements: 3.2, 8.2_
  
  - [ ]* 7.3 Write unit tests untuk hazard placement
    - Test minimum spike groups (5)
    - Test minimum moving platforms (2)
    - Test kombinasi moving platform + enemy exists
    - _Requirements: 3.1, 3.2, 3.5_
  
  - [ ]* 7.4 Write property test untuk spike collision damage
    - **Property 1: Spike Collision Damage**
    - **Validates: Requirements 3.3**

- [x] 8. Checkpoint - Test hazards dan enemy interactions
  - Ensure spikes deal damage correctly
  - Ensure moving platforms move smoothly
  - Ensure enemies detect dan attack player
  - Ask user if questions arise

- [ ] 9. Implement collectibles system
  - [x] 9.1 Place keys di different difficulty areas
    - Add Key1 di (1600, 1250) - Path B, medium difficulty
    - Add Key2 di (3100, 650) - Path C, high risk area
    - Add Key3 di (2800, 400) - Secret area, very hard
    - Verify key.gd script attached ke all keys
    - _Requirements: 4.1, 4.5, 8.2_
  
  - [x] 9.2 Place final chest near exit
    - Add Chest di (4600, 1750)
    - Configure chest to require 3 keys
    - Verify chest.gd script attached
    - _Requirements: 4.2, 8.2_
  
  - [x] 9.3 Place bonus items di hard-to-reach areas
    - Add BonusItem1 di (1000, 1550) - Path A, easy
    - Add BonusItem2 di (2300, 1150) - Path B, moving platform timing
    - Add BonusItem3 di (3600, 550) - Path C, secret area
    - _Requirements: 9.1, 9.4_
  
  - [ ]* 9.4 Write unit tests untuk collectible placement
    - Test correct number of keys (2-3)
    - Test final chest exists dan requires all keys
    - Test minimum bonus items (3)
    - Test minimal 1 key di high risk area
    - _Requirements: 4.1, 4.2, 4.5, 9.1_
  
  - [ ]* 9.5 Write property test untuk key-chest system
    - **Property 2: Key-Chest System Integrity**
    - **Validates: Requirements 4.3, 4.4**
  
  - [ ]* 9.6 Write property test untuk bonus collection achievement
    - **Property 7: Bonus Collection Achievement**
    - **Validates: Requirements 9.2**

- [ ] 10. Setup exit portal dan level completion
  - [x] 10.1 Place exit portal di end position
    - Add ExitPortal di (4800, 1750)
    - Configure activation requirement (chest opened)
    - Add visual marker atau animation
    - Create trigger area (100 pixel radius)
    - _Requirements: 6.2_
  
  - [ ]* 10.2 Write property test untuk level completion flow
    - **Property 3: Level Completion Flow**
    - **Validates: Requirements 6.3, 6.5**
  
  - [ ]* 10.3 Write property test untuk perfect clear bonus
    - **Property 8: Perfect Clear Bonus**
    - **Validates: Requirements 9.5**

- [ ] 11. Checkpoint - Test full gameplay loop
  - Ensure player dapat spawn, collect keys, open chest, reach exit
  - Ensure all collectibles trackable
  - Ensure level completion triggers correctly
  - Ask user if questions arise

- [ ] 12. Polish dan final integration
  - [~] 12.1 Add visual feedback dan polish
    - Add spawn point visual marker
    - Add key collection effects
    - Add chest opening animation trigger
    - Add exit portal activation visual
    - _Requirements: 6.1, 6.2_
  
  - [~] 12.2 Verify all script attachments dan configurations
    - Double-check all nodes have correct scripts
    - Verify collision layers properly configured
    - Test scene loading di Godot 4.6.1
    - _Requirements: 8.2, 8.3, 8.4, 8.5_
  
  - [ ]* 12.3 Write integration tests untuk full gameplay
    - Test complete playthrough dari spawn ke exit
    - Test death dan respawn flow
    - Test all collectible interactions
    - _Requirements: 6.4, 8.4_

- [~] 13. Final checkpoint - Complete testing dan validation
  - Run all unit tests dan property tests
  - Ensure all tests pass
  - Verify level playable end-to-end
  - Ask user if questions arise atau ready for release

## Notes

- Tasks marked dengan `*` adalah optional dan dapat di-skip untuk faster MVP
- Setiap task references specific requirements untuk traceability
- Checkpoints ensure incremental validation di key milestones
- Property tests validate universal correctness properties dengan 100+ iterations
- Unit tests validate specific configurations dan edge cases
- Scene construction menggunakan Godot editor, bukan pure code
- All existing scripts (player.gd, predator_plant.gd, etc.) di-reuse tanpa modifikasi
