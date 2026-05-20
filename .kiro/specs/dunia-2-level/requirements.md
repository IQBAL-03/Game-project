# Requirements Document: Dunia 2 Level

## Introduction

Dunia 2 adalah level kedua dalam game platformer action 2D yang menawarkan tantangan lebih tinggi dibanding Dunia 1. Level ini dirancang untuk menguji kemampuan player yang sudah menguasai mekanik dasar game (movement, combat, platforming) dengan layout yang lebih kompleks, lebih banyak musuh, obstacle berbahaya, dan puzzle yang lebih menantang.

## Glossary

- **Game_System**: Sistem utama game platformer action 2D berbasis Godot 4.6.1
- **Dunia_2**: Scene level kedua dengan tingkat kesulitan lebih tinggi
- **Player**: Karakter yang dikendalikan user dengan kemampuan walk, run, jump, double jump, climb, dan attack
- **Predator_Plant**: Enemy AI dengan kemampuan detect player dan attack otomatis
- **Key**: Item collectible yang diperlukan untuk membuka chest
- **Chest**: Container yang memerlukan key untuk dibuka
- **Spike**: Obstacle berbahaya yang memberikan damage ke player
- **Moving_Platform**: Platform yang bergerak secara otomatis dalam pola tertentu
- **Exit_Portal**: Titik akhir level yang menandakan level selesai
- **Spawn_Point**: Titik awal player muncul di level
- **Camera_Bounds**: Batas area kamera mengikuti player

## Requirements

### Requirement 1: Level Layout dan Struktur

**User Story:** Sebagai player, saya ingin level yang lebih menantang dengan layout kompleks, sehingga saya bisa merasakan progression difficulty yang memuaskan.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki platform dengan ketinggian minimal 2x lebih tinggi dari platform tertinggi di Dunia 1
2. THE Dunia_2 SHALL memiliki gap antar platform dengan lebar minimal 1.5x lebih lebar dari gap terlebar di Dunia 1
3. THE Dunia_2 SHALL memiliki minimal 3 jalur berbeda dari spawn point ke exit portal
4. WHEN player memilih jalur dengan risk lebih tinggi, THE Game_System SHALL menyediakan reward berupa bonus items atau shortcut
5. THE Dunia_2 SHALL memiliki total panjang level minimal 3x lebih panjang dari Dunia 1

### Requirement 2: Enemy Placement dan Difficulty

**User Story:** Sebagai player, saya ingin menghadapi musuh yang ditempatkan secara strategis, sehingga combat menjadi lebih menantang dan memerlukan strategi.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki 3 hingga 5 Predator_Plant yang ditempatkan di posisi strategis
2. WHEN Predator_Plant ditempatkan, THE Game_System SHALL memastikan minimal 2 enemy berada di platform sempit atau dekat gap
3. WHEN player mendekati area dengan kombinasi obstacle dan enemy, THE Game_System SHALL memastikan player memiliki ruang untuk manuver
4. THE Dunia_2 SHALL memiliki minimal 1 area dengan 2 Predator_Plant yang berdekatan
5. WHEN semua Predator_Plant dikalahkan, THE Game_System SHALL memberikan notifikasi optional challenge complete

### Requirement 3: Obstacle dan Hazards

**User Story:** Sebagai player, saya ingin menghadapi berbagai obstacle berbahaya, sehingga platforming menjadi lebih challenging dan memerlukan timing yang tepat.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki minimal 5 area dengan Spike yang ditempatkan di posisi berbahaya
2. THE Dunia_2 SHALL memiliki minimal 2 Moving_Platform dengan pola pergerakan berbeda
3. WHEN player menyentuh Spike, THE Game_System SHALL memberikan damage ke Player
4. WHEN Moving_Platform bergerak, THE Game_System SHALL memastikan pergerakan smooth dan predictable
5. THE Dunia_2 SHALL memiliki minimal 1 area dengan kombinasi Moving_Platform dan Predator_Plant

### Requirement 4: Puzzle System dengan Multiple Keys

**User Story:** Sebagai player, saya ingin menyelesaikan puzzle dengan multiple keys dan chests, sehingga exploration menjadi lebih rewarding.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki 2 hingga 3 Key yang tersebar di lokasi berbeda
2. THE Dunia_2 SHALL memiliki 1 final Chest yang memerlukan semua Key untuk dibuka
3. WHEN player mengambil Key, THE Game_System SHALL menyimpan status key collected
4. WHEN player membuka final Chest tanpa mengumpulkan semua Key, THE Game_System SHALL mencegah chest terbuka
5. THE Dunia_2 SHALL memiliki minimal 1 Key yang ditempatkan di area dengan high risk (dekat enemy atau obstacle)

### Requirement 5: Visual Theme dan Atmosphere

**User Story:** Sebagai player, saya ingin merasakan atmosphere yang berbeda dari Dunia 1, sehingga setiap level terasa unik dan immersive.

#### Acceptance Criteria

1. THE Dunia_2 SHALL menggunakan swamp theme assets yang sudah tersedia
2. THE Dunia_2 SHALL memiliki background dengan tone warna lebih gelap dibanding Dunia 1
3. THE Dunia_2 SHALL memiliki minimal 5 environment details seperti stalactites atau flying stones
4. WHEN level dimuat, THE Game_System SHALL menampilkan visual yang konsisten dengan swamp theme
5. THE Dunia_2 SHALL memiliki parallax background untuk depth perception

### Requirement 6: Spawn Point dan Exit System

**User Story:** Sebagai player, saya ingin spawn point yang jelas dan exit portal yang mudah dikenali, sehingga objective level jelas.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki 1 Spawn_Point yang jelas di awal level
2. THE Dunia_2 SHALL memiliki 1 Exit_Portal yang jelas di akhir level
3. WHEN player mencapai Exit_Portal, THE Game_System SHALL menandai level sebagai complete
4. WHEN player mati, THE Game_System SHALL respawn player di Spawn_Point
5. THE Exit_Portal SHALL hanya dapat diakses setelah final Chest dibuka

### Requirement 7: Camera System dan Bounds

**User Story:** Sebagai player, saya ingin kamera mengikuti movement saya dengan smooth, sehingga gameplay terasa comfortable.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki Camera_Bounds yang sesuai dengan ukuran level
2. WHEN player bergerak, THE Game_System SHALL memastikan kamera mengikuti player dengan smooth
3. WHEN player mendekati edge level, THE Game_System SHALL mencegah kamera menampilkan area di luar bounds
4. THE Camera_Bounds SHALL mencakup seluruh area playable di Dunia_2
5. WHEN player berada di area dengan vertical movement tinggi, THE Game_System SHALL menyesuaikan kamera untuk visibility optimal

### Requirement 8: Technical Implementation dan Reusability

**User Story:** Sebagai developer, saya ingin reuse existing scripts dan systems, sehingga development lebih efisien dan maintainable.

#### Acceptance Criteria

1. THE Dunia_2 SHALL menggunakan scene file baru bernama dunia_2.tscn
2. THE Dunia_2 SHALL reuse existing scripts: player.gd, predator_plant.gd, key.gd, chest.gd
3. THE Dunia_2 SHALL menggunakan collision layers yang proper untuk platforms, hazards, dan entities
4. WHEN Dunia_2 dimuat, THE Game_System SHALL memastikan semua scripts berfungsi tanpa modifikasi
5. THE Dunia_2 SHALL compatible dengan Godot 4.6.1

### Requirement 9: Bonus Items dan Optional Objectives

**User Story:** Sebagai player, saya ingin optional objectives dan bonus items, sehingga ada replay value dan exploration incentive.

#### Acceptance Criteria

1. THE Dunia_2 SHALL memiliki minimal 3 bonus items yang tersebar di area sulit dijangkau
2. WHEN player mengumpulkan semua bonus items, THE Game_System SHALL memberikan notifikasi achievement
3. WHEN player mengalahkan semua Predator_Plant, THE Game_System SHALL menandai optional challenge sebagai complete
4. THE Dunia_2 SHALL memiliki minimal 1 secret area dengan bonus item
5. WHEN player menyelesaikan level tanpa mati, THE Game_System SHALL memberikan perfect clear bonus
