# 📋 Dokumen Pengembangan Game "The Witch"

## 🎮 Ringkasan Analisis Game Saat Ini

### Fitur yang Sudah Ada
- ✅ Sistem pergerakan player (jalan, lari, loncat, double jump)
- ✅ Sistem combat dasar (serangan klik kiri)
- ✅ Sistem health dengan visual feedback (flashing merah saat terkena damage)
- ✅ Musuh dasar: Predator Plant dengan AI sederhana
- ✅ Sistem interaksi: Kunci & Peti
- ✅ Sistem climbing (tangga/ladder)
- ✅ Hazard environment (duri/thorns)
- ✅ UI health bar dengan heart system
- ✅ Game over screen
- ✅ Pause menu

### Kekuatan Game
- 🎨 Tema visual wizard/penyihir yang menarik
- 🎯 Mekanik dasar yang solid dan responsif
- 💪 Sistem combat yang sudah sinkron dengan animasi
- 🏃 Movement yang smooth dengan fitur double-tap untuk lari

### Area yang Perlu Dikembangkan
- 🔄 Variasi combat masih terbatas (hanya 1 jenis serangan)
- 👾 Hanya 1 jenis musuh (Predator Plant)
- 🗺️ Belum ada sistem progression antar level/dunia
- ⚡ Belum ada sistem magic/skill khusus wizard
- 🎵 Belum terlihat sistem audio/music
- 💎 Belum ada sistem collectibles atau reward

---

## 🚀 Rekomendasi Pengembangan

### 📊 Target Spesifikasi
- **Target Pemain**: Remaja ke atas
- **Gaya Gameplay**: Casual santai dengan fokus pemandangan & combat seimbang
- **Durasi Total**: Minimal 1 jam gameplay
- **Struktur**: Multi-dunia/level dengan save system
- **Prioritas**: Sistem combat & variasi musuh/boss

---

## 🎯 FASE 1: Pengembangan Sistem Combat (Prioritas Tinggi)

### 1.1 Sistem Magic/Skill untuk Wizard

#### A. Serangan Magic Dasar (3 Elemen)
Karena ada 3 karakter wizard (Fire, Lightning, Wanderer), manfaatkan untuk sistem elemen:

**🔥 Fire Magic**
- **Fireball**: Proyektil api jarak jauh (damage sedang, area kecil)
- **Fire Wave**: Serangan area di depan player (damage tinggi, jarak pendek)
- **Burn Effect**: Musuh terbakar, damage over time 3 detik

**⚡ Lightning Magic**
- **Lightning Bolt**: Serangan cepat vertikal dari atas (damage tinggi, single target)
- **Chain Lightning**: Menyambar 3 musuh terdekat (damage sedang)
- **Stun Effect**: Musuh terstun 2 detik, tidak bisa bergerak

**🌟 Arcane Magic (Wanderer)**
- **Magic Missile**: 3 proyektil homing yang mengejar musuh
- **Arcane Shield**: Barrier yang menyerap 2 hit damage
- **Slow Effect**: Musuh melambat 50% selama 4 detik

#### B. Sistem Combo
- **Light Attack** (klik kiri): 3-hit combo dengan animasi berbeda
  - Hit 1: Damage 1x
  - Hit 2: Damage 1.2x
  - Hit 3: Damage 1.5x + knockback
- **Heavy Attack** (tahan klik kiri 1 detik): Charged attack dengan damage 2x
- **Air Attack**: Serangan khusus saat di udara (slam down)

#### C. Sistem Mana
```
Max Mana: 100
Regenerasi: 5 mana/detik
Biaya Skill:
- Skill Tier 1: 20 mana
- Skill Tier 2: 35 mana
- Skill Tier 3: 50 mana
```

#### D. Skill Tree & Upgrade System

**Currency System:**
- 💎 **Mana Crystal**: Untuk upgrade stats & skill
- ⭐ **Skill Point**: Untuk unlock skill baru (dapat dari boss/quest)

**Cara Dapat:**
- Mana Crystal: Kumpulkan di level (5-15 per dunia)
- Skill Point: 1 per mini-boss, 2 per final boss, 1 per secret quest

---

## 👾 FASE 2: Variasi Musuh & Boss (Prioritas Tinggi)

### 2.1 Musuh Tier 1 (Dunia 1-2)

#### 🌿 Predator Plant (Sudah Ada - Perlu Enhancement)
- **Varian Baru**: 
  - **Poison Plant**: Serangan meninggalkan poison pool di tanah
  - **Spitter Plant**: Menembak proyektil biji dari jarak jauh
- **Behavior**: Stationary, area denial
- **Health**: 2 hit
- **Damage**: 0.5 heart

#### 🦇 Flying Bat
- **Behavior**: Terbang patrol horizontal, dive attack ke player
- **Pattern**: Terbang tinggi → deteksi player → dive → kembali ke posisi
- **Health**: 1 hit
- **Damage**: 0.5 heart
- **Drop**: 20% chance mana potion

#### 🐛 Ground Crawler
- **Behavior**: Patrol di tanah, charge attack saat player dekat
- **Pattern**: Jalan lambat → deteksi player → charge cepat 3 detik
- **Health**: 2 hit
- **Damage**: 1 heart (saat charge)
- **Special**: Bisa memanjat dinding

#### 👻 Ghost Wisp
- **Behavior**: Float melayang, teleport random, shoot magic
- **Pattern**: Muncul → shoot 3 proyektil → teleport → repeat
- **Health**: 3 hit (tapi hanya bisa di-damage saat tidak teleport)
- **Damage**: 0.5 heart per proyektil
- **Special**: Immune terhadap physical attack, hanya magic damage

### 2.2 Musuh Tier 2 (Dunia 3-4)

#### 🗡️ Skeleton Warrior
- **Behavior**: Patrol, chase player, melee combo attack
- **Pattern**: Idle → chase → 2-hit combo → cooldown 2 detik
- **Health**: 5 hit
- **Damage**: 1 heart per hit
- **Special**: Bisa block attack player (30% chance)

#### 🏹 Goblin Archer
- **Behavior**: Keep distance, shoot arrow, retreat jika player dekat
- **Pattern**: Aim 1 detik → shoot → reload 2 detik
- **Health**: 3 hit
- **Damage**: 1 heart
- **Special**: Arrow bisa di-destroy dengan magic attack

#### 🧟 Zombie Brute
- **Behavior**: Slow movement, high damage, grab attack
- **Pattern**: Walk slow → grab attack (range 1.5x melee) → slam
- **Health**: 8 hit
- **Damage**: 2 heart (grab+slam)
- **Special**: Super armor (tidak bisa di-knockback)

### 2.3 Mini-Boss (Setiap 2 Dunia)

#### 🌳 Ancient Treant (Dunia 2 - Mountain Pass Boss)
**Tema**: Guardian of the Forest
**Arena**: Platform area dengan jurang di kiri-kanan

**Phase 1** (100% - 50% HP):
```
Attack Pattern:
1. Root Spike: Akar keluar dari tanah di posisi player (telegraphed 1 sec)
   - Damage: 1 heart
   - Dodge: Jump atau dash saat warning muncul

2. Summon Plants: Panggil 2 Predator Plant
   - Spawn setiap 20 detik
   - Kill plants atau focus boss

3. Slam Attack: Pukul tanah, shockwave horizontal
   - Damage: 1.5 heart
   - Dodge: Jump over shockwave
   - Range: Full arena width

4. Vine Whip: Cambuk dengan vine (melee range)
   - Damage: 1 heart
   - 2-hit combo
   - Dodge: Keep distance atau dash away
```

**Phase 2** (50% - 0% HP):
```
Enrage Mode:
- Movement speed +30%
- Attack speed +20%
- Summon 3 plants (instead of 2)

New Attack:
5. Root Prison: Akar keluar melingkar, trap player 3 detik
   - Damage: 0.5 heart/sec (total 1.5 heart)
   - Escape: Mash attack button untuk break free
   - Telegraphed: Ground glow merah 1 sec sebelum trap

Strategy:
- Kill summoned plants untuk breathing room
- Dodge shockwave dengan jump timing
- Attack saat boss recovery (after slam)
- Use magic untuk safe damage dari jarak jauh
```

**Stats:**
- Health: 50 hit
- Damage: 1-1.5 heart per attack
- Speed: Slow (Phase 1), Medium (Phase 2)

**Reward:**
- 35 Mana Crystals
- 2 Skill Points
- 1 Lore Tablet
- Unlock: Mountain Pass → Abandoned Village

---

#### ⚡ Thunder Golem (Dunia 4 - Thunder Temple Boss)
**Tema**: Ancient Guardian of Lightning
**Arena**: Temple platform dengan electric pillars

**Phase 1** (100% - 60% HP):
```
Attack Pattern:
1. Lightning Strike: Petir jatuh di 3 posisi random
   - Damage: 2 heart per strike
   - Telegraphed: Ground glow kuning 1.5 sec
   - Dodge: Move away dari warning area

2. Charge Attack: Lari cepat ke arah player
   - Damage: 1.5 heart + knockback
   - Telegraphed: Golem crouch 1 sec
   - Dodge: Jump over atau dash perpendicular

3. Electric Field: Area di sekitar golem (radius 2m)
   - Damage: 0.5 heart/sec
   - Duration: 5 detik
   - Strategy: Keep distance, use ranged attack

4. Thunder Punch: Melee combo 3-hit
   - Damage: 1 heart per hit
   - Dodge: Dash away atau keep range
```

**Phase 2** (60% - 30% HP):
```
New Mechanics:
- Summon 2 Ghost Wisp (magic enemy)
- Electric pillars activate (shock player jika sentuh)

New Attack:
5. Lightning Storm: Petir jatuh terus-menerus 8 detik
   - Damage: 2 heart per strike
   - Pattern: Random, 1 strike per second
   - Strategy: Keep moving, don't stop!

6. Teleport: Golem teleport ke posisi random
   - Frequency: Every 15 seconds
   - Warning: Electric flash before teleport
```

**Phase 3** (30% - 0% HP):
```
Berserk Mode:
- All attacks 30% faster
- Electric field always active
- No more summons (focus on boss)

Ultimate Attack:
7. Mega Lightning: Charge 3 detik, petir raksasa
   - Damage: 3 heart (massive!)
   - Telegraphed: Golem glow bright, screen shake
   - Dodge: MUST dodge! Run to corner, dash saat strike
   - Frequency: Every 20 seconds

Strategy:
- Phase 1-2: Kill wisps first, then focus boss
- Phase 3: Aggressive! Burst damage before Mega Lightning
- Use Lightning resistance skill if available
- Save health potions untuk phase 3
```

**Stats:**
- Health: 80 hit
- Damage: 1-3 heart per attack
- Speed: Medium (Phase 1-2), Fast (Phase 3)

**Reward:**
- 40 Mana Crystals
- 2 Skill Points
- 1 Heart Container
- 1 Lore Tablet
- Unlock: Thunder Temple → Volcanic Cavern

---

#### 🌋 Lava Titan (Dunia 5 - Volcanic Cavern Boss)
**Tema**: Molten Giant of Fire
**Arena**: Platform di atas lava lake (falling = instant death)

**Phase 1** (100% - 50% HP):
```
Attack Pattern:
1. Lava Ball: Lempar bola lava (proyektil)
   - Damage: 1.5 heart
   - Speed: Medium
   - Dodge: Sidestep atau dash

2. Ground Pound: Pukul tanah, platform shake
   - Damage: 2 heart
   - Effect: Player stumble (can't move 1 sec)
   - Dodge: Jump saat impact

3. Lava Wave: Lava naik dari bawah, sweep horizontal
   - Damage: 2 heart + burn (0.5 heart/sec for 3 sec)
   - Telegraphed: Lava glow 2 sec
   - Dodge: Jump to higher platform

4. Fire Breath: Cone attack di depan
   - Damage: 1 heart/sec
   - Duration: 3 detik
   - Dodge: Move behind boss atau far away
```

**Phase 2** (50% - 0% HP):
```
Arena Change:
- Lava level rises slowly (time pressure!)
- Some platforms disappear
- Must finish fight in 3 minutes or lava reaches top

New Attacks:
5. Meteor Rain: Meteor jatuh dari atas (5 meteors)
   - Damage: 2 heart per meteor
   - Pattern: Random spread
   - Dodge: Keep moving, watch shadows

6. Eruption: Lava pillar keluar dari random platform
   - Damage: 3 heart (massive!)
   - Telegraphed: Platform glow red 1 sec
   - Dodge: Jump to different platform immediately

7. Enrage Combo: Ground Pound → Fire Breath → Lava Ball
   - Full combo if hit: 4.5 heart damage!
   - Strategy: Dodge first attack to avoid combo

Strategy:
- Phase 1: Learn patterns, conserve resources
- Phase 2: Aggressive! Time pressure!
- Prioritize dodging over attacking
- Use fire resistance if available
- Keep track of safe platforms
```

**Stats:**
- Health: 70 hit
- Damage: 1.5-3 heart per attack
- Speed: Slow but powerful
- Time Limit: 3 minutes (Phase 2)

**Reward:**
- 45 Mana Crystals
- 2 Skill Points
- 1 Heart Container
- 1 Lore Tablet
- Unlock: Volcanic Cavern → Dark Castle

---

### 2.4 Final Boss

#### 🐉 ANCIENT DRAGON (Dunia 6 - Dark Castle Final Boss)
**Tema**: The Ultimate Challenge - Legendary Dragon
**Arena**: Castle rooftop, open sky, epic setting

**Intro Cutscene:**
```
- Dragon lands dengan dramatic entrance
- Roar yang menggelegar (screen shake)
- "You dare challenge me, little wizard?"
- Health bar muncul: [████████████████] ANCIENT DRAGON
```

---

**PHASE 1: GROUNDED ASSAULT** (100% - 75% HP)
```
Dragon di tanah, melee + breath attacks

Attack Pattern:
1. Claw Swipe: Cakar 2-hit combo
   - Damage: 1.5 heart per hit
   - Range: Melee
   - Dodge: Dash backward atau jump

2. Tail Whip: Ekor sweep 180°
   - Damage: 2 heart + knockback
   - Range: Behind dragon
   - Dodge: Stay in front atau jump over

3. Fire Breath: Cone api di depan
   - Damage: 1 heart/sec
   - Duration: 4 detik
   - Dodge: Move to side atau behind dragon

4. Bite Attack: Lunging bite
   - Damage: 2.5 heart
   - Telegraphed: Dragon crouch 1 sec
   - Dodge: Dash perpendicular

5. Wing Gust: Flap wings, push player back
   - Damage: 0 (no damage)
   - Effect: Knockback + can't attack 2 sec
   - Dodge: Dash forward atau hold ground

Strategy:
- Attack from side (avoid front and back)
- Punish after Fire Breath (long recovery)
- Watch for tail whip if behind
- Save mana for later phases
```

---

**PHASE 2: AERIAL DOMINANCE** (75% - 50% HP)
```
Dragon terbang! Arena changes!

Cutscene: Dragon roar → fly up → "Face my true power!"

New Mechanics:
- Dragon flies around arena
- Can't melee attack (must use magic!)
- Falling rocks from ceiling (hazard)

Attack Pattern:
1. Dive Bomb: Terbang tinggi → dive ke player
   - Damage: 3 heart
   - Telegraphed: Dragon shadow on ground
   - Dodge: Move away dari shadow

2. Fireball Barrage: Shoot 5 fireballs berturut-turut
   - Damage: 1.5 heart per fireball
   - Pattern: Spread pattern
   - Dodge: Weave between fireballs

3. Flame Pillar: Fire pillar keluar dari tanah (3 pillars)
   - Damage: 2 heart + burn
   - Telegraphed: Ground glow 1.5 sec
   - Dodge: Move to safe area

4. Strafe Run: Fly horizontal, fire breath sweep
   - Damage: 1.5 heart/sec
   - Duration: 3 detik
   - Dodge: Follow dragon movement, stay behind

5. Summon Minions: Call 3 Flying Bats
   - Distraction tactic
   - Strategy: Ignore or quick kill

Vulnerable Moment:
- After Dive Bomb, dragon stunned 3 sec on ground
- ATTACK WINDOW! Burst damage!
- Then dragon flies again

Strategy:
- Use magic attacks (can't melee)
- Dodge falling rocks while fighting
- Wait for dive bomb → punish stun
- Kill bats if overwhelming
- Manage mana carefully!
```

---

**PHASE 3: INFERNO RAGE** (50% - 25% HP)
```
Dragon lands, enraged mode!

Cutscene: Dragon roar → arena on fire → "You will BURN!"

Arena Change:
- Fire patches on ground (damage over time)
- Less safe space
- Intense music

Enhanced Attacks:
- All attacks 40% faster
- All attacks deal +0.5 heart damage
- Fire Breath now leaves fire patches

New Ultimate Attack:
6. Inferno Nova: Dragon charge 3 sec → massive explosion
   - Damage: 4 heart (almost lethal!)
   - Range: Full arena
   - Telegraphed: Dragon glow red, screen shake
   - Dodge: MUST hide behind pillars (4 pillars in arena)
   - Frequency: Every 30 seconds

7. Meteor Shower: Meteors jatuh dari langit (10 meteors)
   - Damage: 2 heart per meteor
   - Duration: 8 detik
   - Pattern: Random
   - Dodge: Keep moving, watch shadows

8. Flame Tornado: Tornado api bergerak di arena
   - Damage: 1 heart/sec
   - Duration: 10 detik
   - Movement: Slow, predictable
   - Dodge: Stay away, kite around arena

Strategy:
- Avoid fire patches (chip damage adds up!)
- PRIORITY: Dodge Inferno Nova (hide behind pillar!)
- Aggressive between ultimates
- Use health potions liberally
- This is the DPS check!
```

---

**PHASE 4: DESPERATE FURY** (25% - 0% HP)
```
Final phase! Dragon goes all out!

Cutscene: Dragon wounded → "I will not fall!" → berserk

Berserk Mode:
- All attacks 50% faster
- Random attack pattern (unpredictable!)
- No more minions (1v1 pure skill)
- Dragon can chain attacks (combo)

Attack Rotation (Random):
- Any attack from Phase 1-3 can happen
- Can combo: Claw → Tail → Fire Breath
- Can combo: Dive Bomb → Fireball Barrage
- Can combo: Meteor Shower → Inferno Nova (deadly!)

New Mechanic:
9. Desperation Charge: Dragon charges wildly 3 times
   - Damage: 2 heart per charge
   - Pattern: Zigzag across arena
   - Dodge: Dash perpendicular, don't panic!

10. Final Roar: Dragon roar → stun player 2 sec
    - Damage: 0
    - Effect: Can't move/attack
    - Follow-up: Always followed by big attack
    - Counter: Use invulnerability skill if available

Victory Condition:
- Deplete all HP
- Dragon falls → epic death animation
- Victory fanfare!

Strategy:
- Stay calm! Don't panic!
- Recognize attack telegraphs
- Dodge first, attack second
- Use ultimate skills (Phoenix Form, Zeus Wrath, etc)
- This is the final test of skill!
- If you have Phoenix Ring, this is the time!
```

---

**DRAGON STATS:**
```
Total Health: 150 hit (longest fight!)
Phase 1: 38 hit (25%)
Phase 2: 38 hit (25%)
Phase 3: 38 hit (25%)
Phase 4: 36 hit (25%)

Damage Range: 1-4 heart per attack
Speed: Medium → Fast → Very Fast
Fight Duration: 8-12 minutes (epic!)
```

**DRAGON REWARDS:**
```
- 50 Mana Crystals (most generous!)
- 3 Skill Points
- 1 Heart Container
- 1 Lore Tablet (final lore piece)
- "Dragon Slayer" Title
- Unlock: True Ending Cutscene
- Unlock: New Game+ Mode
- Unlock: Dragon Skin (cosmetic)
```

---

#### 🎬 Victory Cutscene
```
- Dragon falls, epic slow-motion
- "You... are strong... wizard..." (last words)
- Dragon dissolves into light particles
- Chest appears (boss chest)
- Camera pan to sunrise
- "The darkness has been lifted..."
- Credits roll (with gameplay stats)
- "Thank you for playing!"
- Post-credit scene: Mysterious figure watching...
  (Hint untuk DLC/sequel)
```

---

### 2.5 Boss Design Philosophy

#### Core Principles

**1. Telegraphing (Fair Warning)**
```
Every attack MUST have clear warning:
- Visual: Glow, charge animation, wind-up
- Audio: Sound cue before attack
- Timing: 0.5-2 sec warning (enough to react)

Example:
- Dragon Fire Breath: Dragon inhale (1.5 sec) → fire
- Player sees + hears → has time to dodge
- Fair = Fun!
```

**2. Phase Transitions (Breathing Room)**
```
Between phases:
- Short cutscene (2-3 sec)
- Boss invulnerable during transition
- Player can heal/reposition
- Music intensity increases

Purpose:
- Give player moment to breathe
- Signal difficulty increase
- Create epic moments
```

**3. Attack Variety (No Spam)**
```
Boss should have 5-7 different attacks:
- Melee attacks (close range)
- Ranged attacks (projectiles)
- Area attacks (AOE)
- Ultimate attacks (rare, powerful)

Rotation:
- Random but balanced
- No spam same attack 3x in a row
- Mix easy and hard attacks
```

**4. Vulnerable Windows (Reward Aggression)**
```
After big attacks, boss has recovery time:
- 2-3 sec vulnerable
- Player can attack safely
- Reward risk-taking

Example:
- Dragon Inferno Nova → 3 sec recovery
- Player: "Now's my chance!" → burst damage
```

**5. Difficulty Curve**
```
Phase 1: Learn patterns (tutorial)
Phase 2: Apply knowledge (test)
Phase 3: Master mechanics (challenge)
Phase 4: Prove mastery (final exam)

Each phase harder than last, but fair!
```

---

#### Boss Balancing

**Damage Balance:**
```
Early Boss (Treant):
- Attacks: 1-1.5 heart
- Player HP: ~6 hearts
- Can take 4-6 hits before death

Mid Boss (Golem):
- Attacks: 1-3 heart
- Player HP: ~7-8 hearts
- Can take 3-5 hits before death

Late Boss (Titan):
- Attacks: 1.5-3 heart
- Player HP: ~8-9 hearts
- Can take 3-4 hits before death

Final Boss (Dragon):
- Attacks: 1-4 heart
- Player HP: ~10 hearts (max)
- Can take 3-4 hits before death

Philosophy: Player can make 3-4 mistakes
Not too punishing, not too easy!
```

**Health Balance:**
```
Mini-Boss: 50-80 hit
- Fight duration: 3-5 minutes
- Not too long (boring)
- Not too short (anticlimactic)

Final Boss: 150 hit
- Fight duration: 8-12 minutes
- Epic length!
- Multiple phases keep it interesting
```

**Attack Speed:**
```
Telegraphing time:
- Small attacks: 0.5-1 sec warning
- Medium attacks: 1-1.5 sec warning
- Big attacks: 2-3 sec warning
- Ultimate attacks: 3-4 sec warning

Faster = less damage
Slower = more damage
Fair trade-off!
```

---

#### Boss Arena Design

**Ancient Treant Arena:**
```
Layout: Flat platform with small gaps
Size: Medium (enough space to dodge)
Hazards: Jurang di kiri-kanan (fall = death)
Gimmick: Summoned plants (adds)
Strategy: Positioning important
```

**Thunder Golem Arena:**
```
Layout: Temple platform with pillars
Size: Large (need space for lightning)
Hazards: Electric pillars (shock if touch)
Gimmick: Teleportation
Strategy: Keep moving, don't corner yourself
```

**Lava Titan Arena:**
```
Layout: Multi-level platforms
Size: Medium (vertical space)
Hazards: Lava below (instant death)
Gimmick: Rising lava (time pressure!)
Strategy: Platform management crucial
```

**Ancient Dragon Arena:**
```
Layout: Open rooftop
Size: Very Large (dragon needs space!)
Hazards: Fire patches, falling rocks, meteors
Gimmick: Phase 2 = aerial combat
Strategy: Adaptability (ground vs air)
```

---

#### Boss Music & Atmosphere

**Music Progression:**
```
Phase 1: Tense, mysterious
Phase 2: Intensity increases
Phase 3: Epic, dramatic
Phase 4: Desperate, climactic

Dynamic Music:
- Music changes with phase
- Intensity matches danger
- Victory fanfare when defeated
```

**Visual Effects:**
```
Boss Aura:
- Mini-boss: Subtle glow
- Final boss: Intense aura + particles

Screen Effects:
- Boss roar: Screen shake
- Ultimate attack: Screen flash
- Low HP: Boss glow red (enrage visual)

Arena Effects:
- Phase transition: Lighting change
- Damage taken: Hit spark + freeze frame
- Victory: Slow-motion death animation
```

---

#### Boss Accessibility Options

**For Casual Players:**
```
Easy Mode:
- Boss HP: -30%
- Boss damage: -25%
- Telegraphing time: +50% (more time to react)
- Vulnerable windows: +50% longer

Story Mode:
- Boss HP: -50%
- Boss damage: -50%
- Can't die (auto-revive with 1 HP)
- For players who just want story
```

**For Hardcore Players:**
```
Hard Mode:
- Boss HP: +50%
- Boss damage: +50%
- Telegraphing time: -25% (faster attacks)
- No health potions allowed

No-Hit Challenge:
- Beat boss without taking damage
- Reward: Special achievement + cosmetic
- For masochists! 😈
```

---

#### Boss Testing Checklist

**Before Release:**
```
✅ All attacks have clear telegraphing
✅ No unfair/unavoidable attacks
✅ Phase transitions work smoothly
✅ Music syncs with phases
✅ Hitboxes are accurate
✅ No bugs/glitches
✅ Difficulty feels fair
✅ Fight duration is appropriate
✅ Rewards feel satisfying
✅ Victory feels earned
```

**Playtesting Questions:**
```
- Can player learn patterns in 2-3 attempts?
- Does boss feel challenging but fair?
- Are there "bullshit" moments? (fix them!)
- Is fight too long/short?
- Do players feel satisfied after victory?
- Would players want to fight again?
```

---

#### Special Boss Mechanics Summary

**Ancient Treant:**
- Summons adds (plant management)
- Shockwave (jump timing)
- Root prison (button mashing)

**Thunder Golem:**
- Teleportation (tracking)
- Lightning storm (movement)
- Electric field (spacing)

**Lava Titan:**
- Rising lava (time pressure)
- Platform management (positioning)
- Fire hazards (environmental awareness)

**Ancient Dragon:**
- Multi-phase (adaptability)
- Aerial combat (ranged focus)
- Ultimate attacks (pillar hiding)
- Longest fight (endurance)

Each boss teaches different skills!

---

---

## 🗺️ FASE 3: Struktur Dunia & Level Design

### 3.1 Konsep Multi-Dunia (Target: 5-6 Dunia)

#### 🌲 Dunia 1: Enchanted Forest (Tutorial + Easy)
- **Durasi**: 8-10 menit
- **Tema**: Hutan ajaib dengan cahaya temaram
- **Musuh**: Predator Plant, Flying Bat
- **Objective**: 
  - Pelajari basic movement & combat
  - Kumpulkan 3 kunci untuk buka gerbang
  - Defeat mini-boss: Giant Predator Plant
- **Collectibles**: 5 mana crystals (hidden)
- **Checkpoint**: 2 checkpoint

#### 🏔️ Dunia 2: Mountain Pass (Easy-Medium)
- **Durasi**: 10-12 menit
- **Tema**: Gunung berbatu dengan jurang
- **Musuh**: Ground Crawler, Flying Bat, Predator Plant
- **Objective**:
  - Platforming challenge dengan climbing
  - Hindari falling rocks (hazard baru)
  - Boss: Ancient Treant
- **Collectibles**: 7 mana crystals, 1 health upgrade
- **Checkpoint**: 3 checkpoint
- **Fitur Baru**: Wind gust (dorong player), moving platform

#### 🏚️ Dunia 3: Abandoned Village (Medium)
- **Durasi**: 12-15 menit
- **Tema**: Desa terbengkalai, suasana horror ringan
- **Musuh**: Ghost Wisp, Skeleton Warrior, Zombie Brute
- **Objective**:
  - Eksplorasi rumah-rumah untuk cari key items
  - Puzzle: Nyalakan 4 torch untuk buka secret door
  - Wave defense: Bertahan 2 menit dari zombie horde
- **Collectibles**: 8 mana crystals, 1 skill scroll
- **Checkpoint**: 3 checkpoint
- **Fitur Baru**: Torch system (area gelap), breakable objects

#### ⚡ Dunia 4: Thunder Temple (Medium-Hard)
- **Durasi**: 12-15 menit
- **Tema**: Kuil kuno dengan elemen listrik
- **Musuh**: Ghost Wisp, Goblin Archer, Electric Elemental (baru)
- **Objective**:
  - Puzzle: Aktifkan 3 generator dengan urutan benar
  - Platforming: Hindari electric trap
  - Boss: Thunder Golem
- **Collectibles**: 10 mana crystals, 1 health upgrade, 1 skill scroll
- **Checkpoint**: 4 checkpoint
- **Fitur Baru**: Electric platform (on/off), laser beam trap

#### 🌋 Dunia 5: Volcanic Cavern (Hard)
- **Durasi**: 15-18 menit
- **Tema**: Gua vulkanik dengan lava
- **Musuh**: Fire Elemental (baru), Lava Golem (baru), semua musuh sebelumnya
- **Objective**:
  - Survival: Lava naik perlahan, harus cepat ke atas
  - Combat gauntlet: 5 wave musuh berturut-turut
  - Mini-boss: Lava Titan
- **Collectibles**: 12 mana crystals, 1 health upgrade
- **Checkpoint**: 4 checkpoint
- **Fitur Baru**: Rising lava (instant death), crumbling platform

#### 🏰 Dunia 6: Dark Castle (Final - Very Hard)
- **Durasi**: 18-20 menit
- **Tema**: Kastil gelap, lair Dark Sorcerer
- **Musuh**: Semua jenis musuh (mixed)
- **Objective**:
  - Infiltrasi kastil (stealth optional)
  - Boss rush: Fight 3 mini-boss sebelumnya (powered up)
  - Final Boss: Dark Sorcerer (multi-phase)
- **Collectibles**: 15 mana crystals, semua secret items
- **Checkpoint**: 5 checkpoint
- **Fitur Baru**: Darkness mechanic, moving spike walls

**Total Durasi Estimasi**: 65-90 menit (sesuai target 1+ jam)

### 3.2 Elemen Level Design

#### Platforming Elements
- **Basic**: Platform statis, moving platform, falling platform
- **Advanced**: Disappearing platform, ice platform (slippery), bouncy platform
- **Interactive**: Switch-activated platform, timed platform

#### Hazards
- **Environmental**: Duri/thorns, lava, poison pool, falling rocks
- **Trap**: Spike trap, arrow trap, laser beam, crushing wall
- **Dynamic**: Rising water/lava, collapsing floor, moving saw blade

#### Puzzle Elements
- **Key & Door**: Sudah ada, expand dengan colored key system
- **Switch & Gate**: Pressure plate, lever, timed gate
- **Light Puzzle**: Torch, mirror untuk reflect light beam
- **Sequence Puzzle**: Activate dalam urutan tertentu

#### Secret Areas
- **Hidden Path**: Dinding palsu, illusory wall
- **Bonus Room**: Challenge room dengan reward bagus
- **Shortcut**: Unlock jalan pintas setelah selesai level

---

## 💎 FASE 4: Sistem Progression & Reward

### 4.1 Sistem Upgrade Lengkap

#### 🎯 Kategori Upgrade

**A. COMBAT UPGRADES (Mana Crystal)**

**1. Damage Upgrade** 💪
```
Tier 1: Base Damage +20% (Cost: 10 crystals)
Tier 2: Base Damage +40% (Cost: 20 crystals)
Tier 3: Base Damage +60% (Cost: 30 crystals)
Tier 4: Base Damage +80% (Cost: 50 crystals)
Tier 5: Base Damage +100% (Cost: 75 crystals)

Contoh: 
- Base damage: 1 heart per hit
- Tier 5: 2 heart per hit (double damage!)
```

**2. Attack Speed Upgrade** ⚡
```
Tier 1: Attack Speed +15% (Cost: 10 crystals)
Tier 2: Attack Speed +30% (Cost: 20 crystals)
Tier 3: Attack Speed +50% (Cost: 35 crystals)

Contoh:
- Base: 1 hit per 0.5 detik (2 hit/detik)
- Tier 3: 1 hit per 0.33 detik (3 hit/detik)
```

**3. Critical Hit Upgrade** 🎯
```
Tier 1: 10% chance crit (2x damage) (Cost: 15 crystals)
Tier 2: 20% chance crit (2x damage) (Cost: 25 crystals)
Tier 3: 30% chance crit (2.5x damage) (Cost: 40 crystals)

Visual: Crit hit muncul "CRITICAL!" text + special effect
```

**4. Combo Mastery** 🔥
```
Tier 1: 4-hit combo (last hit 2x damage) (Cost: 20 crystals)
Tier 2: 5-hit combo (last hit 2.5x damage) (Cost: 35 crystals)
Tier 3: Combo window +50% (lebih mudah maintain combo) (Cost: 25 crystals)

Unlock: Combo counter muncul di HUD
```

---

**B. MAGIC UPGRADES (Mana Crystal)**

**1. Skill Damage Upgrade** ✨
```
Per Skill (Fire/Lightning/Arcane):
Tier 1: Skill Damage +25% (Cost: 15 crystals)
Tier 2: Skill Damage +50% (Cost: 25 crystals)
Tier 3: Skill Damage +75% (Cost: 40 crystals)

Total: 9 upgrade path (3 skill × 3 tier)
```

**2. Mana Efficiency** 💧
```
Tier 1: Mana Cost -10% (Cost: 12 crystals)
Tier 2: Mana Cost -20% (Cost: 22 crystals)
Tier 3: Mana Cost -30% (Cost: 35 crystals)
Tier 4: Mana Cost -40% (Cost: 50 crystals)

Contoh:
- Fireball base cost: 20 mana
- Tier 4: Fireball cost: 12 mana (hemat 8 mana!)
```

**3. Mana Capacity** 🔋
```
Tier 1: Max Mana +20 (100 → 120) (Cost: 10 crystals)
Tier 2: Max Mana +40 (120 → 140) (Cost: 20 crystals)
Tier 3: Max Mana +60 (140 → 160) (Cost: 30 crystals)
Tier 4: Max Mana +80 (160 → 180) (Cost: 45 crystals)
Tier 5: Max Mana +100 (180 → 200) (Cost: 60 crystals)

Max possible: 200 mana (2x base capacity)
```

**4. Mana Regeneration** ⚡
```
Tier 1: Regen +2/sec (5 → 7/sec) (Cost: 15 crystals)
Tier 2: Regen +4/sec (7 → 9/sec) (Cost: 25 crystals)
Tier 3: Regen +6/sec (9 → 11/sec) (Cost: 40 crystals)

Bonus: Regen 2x lebih cepat saat tidak combat (5 detik tanpa hit/attack)
```

**5. Cooldown Reduction** ⏱️
```
Tier 1: Cooldown -15% (Cost: 18 crystals)
Tier 2: Cooldown -30% (Cost: 30 crystals)
Tier 3: Cooldown -45% (Cost: 50 crystals)

Contoh:
- Lightning Bolt base cooldown: 8 detik
- Tier 3: Lightning Bolt cooldown: 4.4 detik
```

---

**C. SURVIVAL UPGRADES (Mana Crystal + Heart Container)**

**1. Max Health Upgrade** ❤️
```
Heart Container (Hidden collectible):
+1 Max Health per container
Total: 5 containers (5 → 10 max health)

Lokasi:
- Dunia 1: Secret cave behind waterfall
- Dunia 2: Top of mountain (hard platforming)
- Dunia 3: Hidden basement in abandoned house
- Dunia 4: Behind electric puzzle
- Dunia 5: Survive lava gauntlet
```

**2. Defense Upgrade** 🛡️
```
Tier 1: Damage Taken -10% (Cost: 15 crystals)
Tier 2: Damage Taken -20% (Cost: 25 crystals)
Tier 3: Damage Taken -30% (Cost: 40 crystals)

Contoh:
- Enemy hit: 1 heart damage
- Tier 3: Enemy hit: 0.7 heart damage
```

**3. Invulnerability Duration** ⏳
```
Tier 1: I-frame +0.5 sec (Cost: 12 crystals)
Tier 2: I-frame +1 sec (Cost: 22 crystals)
Tier 3: I-frame +1.5 sec (Cost: 35 crystals)

Base: 1 detik invulnerable setelah kena hit
Tier 3: 2.5 detik invulnerable (lebih aman!)
```

**4. Life Steal** 🩸
```
Tier 1: 5% chance heal 0.5 heart saat hit enemy (Cost: 20 crystals)
Tier 2: 10% chance heal 0.5 heart (Cost: 35 crystals)
Tier 3: 15% chance heal 1 heart (Cost: 55 crystals)

Sustain build: Cocok untuk aggressive playstyle
```

---

**D. MOBILITY UPGRADES (Mana Crystal)**

**1. Movement Speed** 🏃
```
Tier 1: Walk +10%, Run +10% (Cost: 10 crystals)
Tier 2: Walk +20%, Run +20% (Cost: 20 crystals)
Tier 3: Walk +30%, Run +30% (Cost: 35 crystals)

Base: 150 walk, 250 run
Tier 3: 195 walk, 325 run (lebih smooth!)
```

**2. Jump Power** 🦘
```
Tier 1: Jump height +15% (Cost: 12 crystals)
Tier 2: Jump height +30% (Cost: 22 crystals)
Tier 3: Jump height +50% (Cost: 35 crystals)

Unlock secret areas yang butuh jump tinggi
```

**3. Air Control** 🌪️
```
Tier 1: Air movement +25% (Cost: 15 crystals)
Tier 2: Air movement +50% (Cost: 25 crystals)
Tier 3: Triple jump unlock! (Cost: 45 crystals)

Tier 3 game changer: 3 kali jump di udara
```

**4. Dash Ability** 💨
```
Unlock: Dash ability (Cost: 30 crystals)
Tier 1: Dash cooldown 3 sec (Cost: 20 crystals)
Tier 2: Dash cooldown 2 sec (Cost: 35 crystals)
Tier 3: Dash invulnerable (i-frame) (Cost: 50 crystals)

Mechanic: Press Shift untuk dash cepat (short distance)
```

---

**E. SKILL UNLOCK (Skill Point)**

**Skill Tree Structure:**
```
FIRE BRANCH:
├─ Tier 1: Fireball (Starter - Free)
├─ Tier 2: Fire Wave (Cost: 1 SP)
├─ Tier 3: Meteor Strike (Cost: 2 SP)
└─ Ultimate: Phoenix Form (Cost: 3 SP)

LIGHTNING BRANCH:
├─ Tier 1: Lightning Bolt (Cost: 1 SP)
├─ Tier 2: Chain Lightning (Cost: 1 SP)
├─ Tier 3: Thunder Storm (Cost: 2 SP)
└─ Ultimate: Zeus Wrath (Cost: 3 SP)

ARCANE BRANCH:
├─ Tier 1: Magic Missile (Cost: 1 SP)
├─ Tier 2: Arcane Shield (Cost: 1 SP)
├─ Tier 3: Time Slow (Cost: 2 SP)
└─ Ultimate: Arcane Explosion (Cost: 3 SP)

PASSIVE BRANCH:
├─ Mana Mastery: Mana regen +50% (Cost: 2 SP)
├─ Combat Expert: Crit chance +10% (Cost: 2 SP)
├─ Survivor: Start with +2 health (Cost: 2 SP)
└─ Treasure Hunter: Show hidden collectibles (Cost: 1 SP)
```

**Total Skill Points Available:**
- Mini-boss (3x): 3 SP
- Final boss (3x): 6 SP
- Secret quest (5x): 5 SP
- **Total: 14 SP**

**Total Skill Points Needed (Full Unlock):**
- Fire: 6 SP
- Lightning: 7 SP
- Arcane: 7 SP
- Passive: 7 SP
- **Total: 27 SP**

**Artinya:** Player harus pilih build! Tidak bisa unlock semua dalam 1 playthrough.
**New Game+:** Carry over SP, bisa unlock sisanya.

---

**F. ULTIMATE SKILLS (Skill Point - Tier 4)**

**🔥 Phoenix Form** (Fire Ultimate - 3 SP)
```
Effect: Transform jadi phoenix 10 detik
- Invulnerable
- Fly freely (no gravity)
- Auto-shoot fireball ke semua enemy
- Damage: 3 heart/sec per enemy
Cooldown: 120 detik
Mana Cost: 80 mana
```

**⚡ Zeus Wrath** (Lightning Ultimate - 3 SP)
```
Effect: Call massive lightning storm
- 20 lightning bolt jatuh random 10 detik
- Each bolt: 5 heart damage + stun 1 sec
- Area: Full screen
Cooldown: 100 detik
Mana Cost: 75 mana
```

**✨ Arcane Explosion** (Arcane Ultimate - 3 SP)
```
Effect: Massive explosion centered on player
- Damage: 10 heart (instant kill most enemy)
- Radius: 5x normal attack range
- Knockback semua enemy
- Player invulnerable during cast (1 sec)
Cooldown: 90 detik
Mana Cost: 70 mana
```

---

### 4.2 Upgrade UI/UX

#### Upgrade Menu Design
```
[TAB] untuk buka Upgrade Menu (bisa pause game)

Layout:
┌─────────────────────────────────────────┐
│  UPGRADE MENU                           │
│  Mana Crystal: 45  |  Skill Point: 3   │
├─────────────────────────────────────────┤
│                                         │
│  [COMBAT]  [MAGIC]  [SURVIVAL]  [MOBILITY]  [SKILLS]
│                                         │
│  ┌─ Damage Upgrade ──────────────┐     │
│  │ Tier 3/5  [████░░]  +60%      │     │
│  │ Next: +80% damage              │     │
│  │ Cost: 50 crystals  [UPGRADE]  │     │
│  └────────────────────────────────┘     │
│                                         │
│  ┌─ Attack Speed ─────────────────┐    │
│  │ Tier 2/3  [███░]  +30%         │    │
│  │ Next: +50% attack speed        │    │
│  │ Cost: 35 crystals  [UPGRADE]   │    │
│  └────────────────────────────────┘     │
│                                         │
│  [Visual preview of upgrade effect]    │
│                                         │
└─────────────────────────────────────────┘
```

#### Upgrade Feedback
- **Visual**: Glow effect saat upgrade
- **Sound**: Satisfying "ding!" sound
- **Stat Display**: Show before/after comparison
- **Preview**: Tooltip explain detail effect

---

### 4.3 Build Variety & Playstyle

#### Build Archetypes

**🔥 BERSERKER BUILD** (Aggressive)
```
Focus: Damage + Attack Speed + Life Steal
Upgrade Priority:
- Max Damage (Tier 5)
- Max Attack Speed (Tier 3)
- Life Steal (Tier 3)
- Critical Hit (Tier 3)
Skills: Fire Wave, Meteor Strike, Phoenix Form
Playstyle: Rush in, spam attack, heal from hits
```

**⚡ GLASS CANNON BUILD** (High Risk High Reward)
```
Focus: Max Magic Damage + Cooldown Reduction
Upgrade Priority:
- All Skill Damage (Tier 3)
- Cooldown Reduction (Tier 3)
- Mana Capacity (Tier 5)
- Mana Efficiency (Tier 4)
Skills: Lightning Bolt, Chain Lightning, Zeus Wrath
Playstyle: Keep distance, spam magic, dodge everything
```

**🛡️ TANK BUILD** (Defensive)
```
Focus: Health + Defense + Sustain
Upgrade Priority:
- All Heart Containers (5/5)
- Defense (Tier 3)
- Invulnerability Duration (Tier 3)
- Life Steal (Tier 3)
Skills: Arcane Shield, Time Slow
Playstyle: Face-tank damage, outlast enemy
```

**💨 SPEEDSTER BUILD** (Hit & Run)
```
Focus: Mobility + Evasion
Upgrade Priority:
- Movement Speed (Tier 3)
- Dash (All tiers)
- Air Control (Tier 3)
- Attack Speed (Tier 3)
Skills: Magic Missile, Time Slow
Playstyle: Never get hit, kite enemy, quick attacks
```

**🎯 BALANCED BUILD** (All-Rounder)
```
Focus: Spread upgrade evenly
Upgrade Priority:
- Damage (Tier 3)
- Mana Capacity (Tier 3)
- Defense (Tier 2)
- Movement Speed (Tier 2)
Skills: Mix dari semua branch
Playstyle: Adaptable, good at everything
```

---

### 4.4 Progression Pacing

#### Crystal Economy (Per Dunia)
```
Dunia 1: 8 crystals available
- Cukup untuk: 1 Tier 1 upgrade

Dunia 2: 12 crystals available (Total: 20)
- Cukup untuk: 2 Tier 1 + 1 Tier 2

Dunia 3: 15 crystals available (Total: 35)
- Cukup untuk: Mulai Tier 3 upgrade

Dunia 4: 18 crystals available (Total: 53)
- Cukup untuk: 1 Tier 4 upgrade

Dunia 5: 22 crystals available (Total: 75)
- Cukup untuk: 1 Tier 5 upgrade

Dunia 6: 25 crystals available (Total: 100)
- Cukup untuk: Max 2-3 stat line

Secret Areas: +30 crystals (Total: 130)
- Reward untuk explorer!
```

#### Recommended Upgrade Path (First Playthrough)
```
Dunia 1 Complete:
→ Damage Tier 1 (10 crystals) - Feel stronger immediately

Dunia 2 Complete:
→ Mana Capacity Tier 1 (10 crystals) - Cast more spells
→ Unlock Dash (30 crystals) - WAIT, need more crystals!

Dunia 3 Complete:
→ Unlock Dash (30 crystals) - Mobility boost!
→ Mana Efficiency Tier 1 (12 crystals) - Sustain magic

Dunia 4 Complete:
→ Damage Tier 2 (20 crystals) - Power spike!
→ Skill Damage Tier 1 (15 crystals) - Magic stronger

Dunia 5 Complete:
→ Damage Tier 3 (30 crystals) - Big power!
→ Defense Tier 1 (15 crystals) - Survive better

Dunia 6 Complete:
→ Damage Tier 4 (50 crystals) - Almost max!
→ Save rest untuk New Game+
```

---

### 4.5 Sistem Collectibles

### 4.5 Sistem Collectibles

#### Mana Crystal 💎
- **Fungsi**: Currency utama untuk upgrade stats
- **Lokasi**: 
  - Visible: Tersebar di level (60% total)
  - Hidden: Di secret area (40% total)
- **Visual**: Kristal biru bercahaya, floating animation
- **Sound**: Satisfying "bling!" saat pickup
- **Total per Dunia**: 8-25 crystal
- **Total Game**: ~130 crystals (100 main + 30 secret)

#### Heart Container ❤️
- **Fungsi**: +1 max health permanent (5 → 10 max)
- **Lokasi**: Hidden di secret area atau boss reward
- **Challenge**: Butuh skill/puzzle untuk dapat
- **Visual**: Heart crystal besar, glow merah
- **Total**: 5 containers

#### Skill Scroll 📜
- **Fungsi**: +1 Skill Point untuk unlock skill
- **Lokasi**: 
  - Boss reward (guaranteed)
  - Secret quest completion
  - Hidden treasure (rare)
- **Visual**: Scroll dengan magic aura
- **Total**: 14 scrolls

#### Mana Potion 🧪
- **Fungsi**: Restore 50 mana instantly
- **Lokasi**: 
  - Drop dari enemy (20% chance)
  - Breakable objects (pot, crate)
  - Checkpoint (1 free potion)
- **Visual**: Blue potion bottle
- **Stackable**: Max 3 potion (hotkey: Q)

#### Health Potion ❤️‍🩹
- **Fungsi**: Restore 2 hearts instantly
- **Lokasi**:
  - Drop dari elite enemy (10% chance)
  - Hidden in secret area
  - Checkpoint (1 free potion)
- **Visual**: Red potion bottle
- **Stackable**: Max 3 potion (hotkey: E)

#### Lore Tablet 📖
- **Fungsi**: Unlock lore/story (optional)
- **Lokasi**: Hidden di setiap dunia (2 per dunia)
- **Reward**: Unlock secret ending jika kumpulkan semua (12 total)
- **Visual**: Stone tablet dengan rune
- **Content**: Short story tentang world lore

---

### 4.5 Chest & Reward System

#### 🎁 Tipe Chest & Isinya

**A. WOODEN CHEST (Common)** 🟤
```
Requirement: 1 Bronze Key
Lokasi: Tersebar di level (3-5 per dunia)
Drop Rate:
- 60%: 3-5 Mana Crystals
- 25%: 1 Health Potion
- 10%: 1 Mana Potion
- 5%: 8 Mana Crystals (lucky!)

Visual: Chest kayu coklat, simple
Animation: Buka → item keluar → floating + sparkle
```

**B. SILVER CHEST (Uncommon)** ⚪
```
Requirement: 1 Silver Key (rare drop/hidden)
Lokasi: Hidden area (1-2 per dunia)
Drop Rate:
- 50%: 10-15 Mana Crystals
- 30%: 2 Health Potion + 1 Mana Potion
- 15%: 3 Health Potion + 2 Mana Potion (jackpot!)
- 5%: 1 Skill Point (super rare!)

Visual: Chest silver dengan ornamen
Animation: Glow effect sebelum buka
```

**C. GOLDEN CHEST (Rare)** 🟡
```
Requirement: 1 Golden Key (boss drop/secret quest)
Lokasi: Secret room (1 per dunia, well hidden)
Drop Rate:
- 50%: 20-25 Mana Crystals
- 30%: 1 Heart Container (+1 max health)
- 20%: 1-2 Skill Points

Visual: Chest emas bercahaya
Animation: Dramatic opening, light beam
Sound: Epic "treasure found" jingle
```

**D. CURSED CHEST (Risk/Reward)** 🟣
```
Requirement: No key needed (suspicious!)
Lokasi: Random spawn (1-2 per dunia)
Mechanic: 
- 60%: Good reward (15 crystals + 2 potions)
- 30%: Mimic! (Enemy chest, harus fight)
  → Defeat mimic: 20 crystals + 1 SP
- 10%: Curse! (lose 1 heart, tapi dapat 25 crystals)

Visual: Chest hitam dengan purple aura
Warning: "This chest looks suspicious..."
Risk/Reward: High risk, high reward!
```

**E. BOSS CHEST (Guaranteed)** 👑
```
Requirement: Defeat boss
Lokasi: Muncul setelah boss mati
Drop (Guaranteed):
- 30-40 Mana Crystals
- 2 Skill Points
- 1 Heart Container (mini-boss & final boss only)
- 1 Lore Tablet
- 3 Health Potion + 2 Mana Potion

Visual: Chest besar dengan boss theme
Animation: Cinematic opening
Always worth it!
```

---

#### 🔑 Key System

**Bronze Key** 🟤
```
Fungsi: Buka Wooden Chest
Lokasi: 
- Tersebar di level (easy to find)
- Drop dari enemy (30% chance)
- Breakable objects (pot, crate, barrel)
Capacity: Max 5 keys
Visual: Key coklat simple
```

**Silver Key** ⚪
```
Fungsi: Buka Silver Chest
Lokasi:
- Hidden area (butuh exploration)
- Elite enemy drop (50% chance)
- Puzzle reward
Capacity: Max 3 keys
Visual: Key silver dengan ornamen
Rare: Lebih susah dapat
```

**Golden Key** 🟡
```
Fungsi: Buka Golden Chest
Lokasi:
- Boss drop (guaranteed)
- Secret quest completion
- Very hidden area (hard platforming/puzzle)
Capacity: Max 2 keys
Visual: Key emas bercahaya
Very Rare: 1-2 per dunia
```

**Master Key** 🔓 *(Optional - Achievement Reward)*
```
Fungsi: Buka SEMUA chest (except Boss)
Lokasi: 
- Achievement: "Open 100 chests"
- New Game+ starting item
Capacity: Infinite use (tidak habis!)
Visual: Key rainbow glow
Ultimate convenience!
```

---

#### 🎲 Chest Placement Strategy

**Dunia 1 (Tutorial):**
```
- 3 Wooden Chest (easy to find)
- 1 Silver Chest (teach exploration)
- 1 Golden Chest (very hidden, optional)
- 1 Boss Chest (guaranteed)

Total Possible Crystals: 50-80
Total Keys Available: 5 Bronze, 2 Silver, 1 Golden
```

**Dunia 2-6 (Scaling):**
```
- 4-5 Wooden Chest
- 2 Silver Chest
- 1 Golden Chest
- 1 Cursed Chest (random spawn)
- 1 Boss Chest

Total Possible Crystals: 100-150 per dunia
Total Keys Available: 6-8 Bronze, 3 Silver, 1-2 Golden
```

**Secret Areas:**
```
- Extra Golden Chest (reward exploration)
- Chest cluster (3 wooden + 1 silver)
- Puzzle chest (solve puzzle → unlock chest)
```

---

#### 🎰 Chest Opening Experience

**Visual Feedback:**
```
1. Player press E near chest
2. Key animation: Key fly ke chest → insert → turn
3. Chest animation: Lid open slowly (suspense!)
4. Item reveal: Item pop out dengan particle effect
5. Item float: Item floating + rotating + sparkle
6. Pickup: Auto-pickup semua item
7. UI notification: "You got: 10 Mana Crystals!" (top screen)
```

**Sound Design:**
```
- Key insert: "Click" sound
- Chest open: "Creak" sound (wood/metal tergantung chest type)
- Item reveal: "Whoosh" + "Sparkle" sound
- Rare item (SP/Heart): Epic music sting (2 sec)
- Golden chest: Dramatic fanfare (3 sec)
```

**Rarity Visual:**
```
Common (Wooden): White glow
Uncommon (Silver): Green glow
Rare (Golden): Blue glow + light particles
Epic (Boss): Purple glow + light beam
Legendary (Cursed - good outcome): Gold glow + screen flash
```

---

#### 🎯 Chest Hunting Incentive

**Achievement System:**
```
"Treasure Hunter I": Open 10 chests
→ Reward: +10 mana crystals

"Treasure Hunter II": Open 30 chests
→ Reward: +20 mana crystals

"Treasure Hunter III": Open 60 chests
→ Reward: +1 Skill Point

"All Chests Found": Open semua chest di 1 dunia
→ Reward: +5 Bronze Keys + +2 Silver Keys

"Chest Master": Open semua chest di semua dunia
→ Reward: Master Key (permanent)

"Risk Taker": Open 10 Cursed Chests
→ Reward: +30 mana crystals

"Mimic Hunter": Defeat 5 Mimics
→ Reward: +1 Skill Point
```

**Minimap Integration:**
```
- Chest icon muncul di minimap (jika dalam radius 50m)
- Opened chest: Gray icon (sudah dibuka)
- Locked chest: Yellow icon (butuh key)
- Secret chest: ??? icon (belum discover)
- Cursed chest: Purple icon (warning!)
```

---

#### 🔄 Chest Respawn & Replayability

**New Game+ Feature:**
```
- Semua chest respawn
- Drop 2x crystals (contoh: Wooden 6-10 crystals)
- Cursed chest spawn rate naik (2-3 per dunia)
- Boss chest drop extra: +1 Skill Point
```

**Chest Counter (UI):**
```
Tampil di pause menu:
"Chests Found: 15/25 (Dunia 1)"
"Total Chests: 78/150 (All Worlds)"

Breakdown per type:
- Wooden: 45/60
- Silver: 18/24
- Golden: 5/6
- Cursed: 8/15
- Boss: 6/6
```

---

#### 💡 Chest Design Tips

**Placement Philosophy:**
```
1. Visible Chest (60%): Reward exploration
   - Di main path, tapi sedikit off-track
   - Contoh: Behind tree, di platform atas

2. Hidden Chest (30%): Reward thorough exploration
   - Di secret area, butuh cari
   - Contoh: Behind fake wall, underwater cave

3. Challenge Chest (10%): Reward skill
   - Butuh platforming/puzzle skill
   - Contoh: Top of tower, end of spike gauntlet
```

**Visual Hints for Hidden Chests:**
```
- Crack di dinding (fake wall)
- Suspicious vines (hidden path)
- Different colored tile (secret floor)
- Torch pattern (puzzle hint)
- Bird/fairy flying around (treasure nearby)
```

**Reward Balance:**
```
- Early game (Dunia 1-2): Lebih banyak crystals (help progression)
- Mid game (Dunia 3-4): Mix crystals + potions (sustain)
- Late game (Dunia 5-6): Lebih banyak SP + Heart (power spike)
```

**Avoid:**
```
❌ Empty chest (always ada reward)
❌ Useless reward (semua berguna)
❌ Mandatory chest (semua optional, tapi encourage exploration)
❌ Unfair hidden (always kasih subtle hint)
❌ Backtracking hell (chest accessible saat first visit)
```

---

#### 🎮 Mimic Mechanic (Cursed Chest)

**Mimic Behavior:**
```
Stats:
- Health: 5 hit
- Damage: 1 heart per bite
- Speed: Medium (chase player)
- Pattern: Jump → Bite → Retreat → Repeat

Visual:
- Chest tiba-tiba tumbuh teeth + eyes
- Tongue keluar (creepy!)
- Jump animation saat attack

Reward (Defeat Mimic):
- 20 Mana Crystals (guaranteed)
- 1 Skill Point (50% chance)
- 2 Health Potion (guaranteed)
```

**Strategy:**
```
- Mimic telegraphs attack (mouth open wide)
- Dodge saat jump attack
- Counter-attack saat retreat
- Use magic untuk safe damage
```

---

#### 📊 Chest Economy Summary

**Total Crystals Available (All Dunia):**
```
Wooden Chest: 60 × 4 avg = 240 crystals
Silver Chest: 24 × 12 avg = 288 crystals
Golden Chest: 6 × 22 avg = 132 crystals
Cursed Chest: 15 × 15 avg = 225 crystals
Boss Chest: 6 × 35 avg = 210 crystals
Scattered: ~100 crystals (loose pickup)

TOTAL: ~1195 crystals
```

**Total Upgrade Cost:**
```
All upgrades maxed: ~1500 crystals
First playthrough: ~1195 crystals (80% upgrades)
New Game+: 2x crystals = ~2390 crystals (max everything!)
```

**Balance:**
- First run: Bisa max 2-3 build path
- New Game+: Bisa max semua
- Encourage replayability!

---

### 4.6 Respec System (Quality of Life)

#### Respec Mechanic
```
Lokasi: Checkpoint/Bonfire
Cost: 20 mana crystals (first time free)
Effect: Reset semua crystal upgrade, refund 100%
Skill Point: TIDAK bisa di-respec (permanent choice)
```

**Use Case:**
- Player mau coba build berbeda
- Salah upgrade, mau fix
- Boss fight butuh build spesifik

**Limitation:**
- Hanya bisa respec di checkpoint (tidak bisa mid-combat)
- Cost naik setiap respec (20 → 30 → 40 → max 50)
- Skill Point tetap permanent (encourage meaningful choice)

---

### 4.7 Achievement & Milestone Rewards

#### Upgrade Milestones
```
"First Blood": Upgrade pertama kali
→ Reward: +5 mana crystals

"Power Spike": Reach Tier 3 di any upgrade
→ Reward: +10 mana crystals

"Maxed Out": Reach Tier 5 di any upgrade  
→ Reward: +1 Skill Point

"Jack of All Trades": Unlock 1 upgrade di semua kategori
→ Reward: +15 mana crystals

"Master of One": Max out 1 kategori upgrade
→ Reward: +1 Skill Point

"Completionist": Unlock semua upgrade available
→ Reward: Infinite mana mode (New Game+ only)
```

---

### 4.8 Visual Progression Feedback

#### Character Visual Changes
```
Damage Tier 1-2: Normal appearance
Damage Tier 3-4: Weapon glow effect
Damage Tier 5: Weapon + aura glow

Mana Tier 3+: Magic circle muncul saat cast
Mana Tier 5: Permanent magic aura

Health 8+: Character size sedikit lebih besar (subtle)
Health 10: Golden outline effect

Speed Tier 3: Speed trail effect saat lari
```

#### Stat Display (Character Menu)
```
[C] untuk buka Character Stats

┌─────────────────────────────────┐
│  CHARACTER STATS                │
├─────────────────────────────────┤
│  Level: 15  (based on upgrades) │
│                                 │
│  ❤️  Health: 7/10               │
│  💧 Mana: 140/160               │
│                                 │
│  ⚔️  Attack: 1.6 (+60%)         │
│  ⚡ Attack Speed: 2.6/sec       │
│  🎯 Crit Chance: 20%            │
│  🔥 Skill Damage: +50%          │
│                                 │
│  🛡️  Defense: -20% damage taken │
│  💨 Move Speed: 195/325         │
│  🦘 Jump Power: +30%            │
│                                 │
│  Playtime: 1h 23m               │
│  Deaths: 12                     │
│  Enemies Killed: 234            │
└─────────────────────────────────┘
```

---

### 4.9 Upgrade Tips & Strategy

#### Early Game (Dunia 1-2)
**Priority: Damage + Mana Capacity**
- Damage Tier 1: Feel stronger immediately
- Mana Capacity Tier 1-2: Cast more spells
- Rationale: Early game, offense > defense

#### Mid Game (Dunia 3-4)  
**Priority: Mobility + Skill Unlock**
- Unlock Dash: Game changer untuk dodge
- Unlock 2nd element skill: Variety
- Movement Speed: Faster = safer
- Rationale: Enemy lebih kuat, butuh mobility

#### Late Game (Dunia 5-6)
**Priority: Defense + Ultimate**
- Defense Tier 2-3: Survive boss fight
- Unlock Ultimate skill: Boss killer
- Life Steal: Sustain di long fight
- Rationale: Boss fight butuh survivability

#### New Game+
**Priority: Max Everything**
- Carry over crystals + SP
- Unlock semua skill
- Max semua stat
- Rationale: God mode, have fun!

---

### 4.10 Upgrade Balance Philosophy

**Design Goals:**
1. **Meaningful Choice**: Player harus pilih, tidak bisa max semua
2. **Build Variety**: Multiple viable build path
3. **Power Fantasy**: Feel stronger setiap upgrade
4. **Fair Progression**: Tidak grind-heavy, natural progression
5. **Replayability**: New Game+ untuk complete build

**Balance Rules:**
- Tier 1-2: Cheap, accessible early
- Tier 3: Mid-game power spike
- Tier 4-5: Late-game luxury, expensive
- Ultimate skills: Endgame reward, game changer
- Total crystals: Cukup untuk ~60% upgrade (first run)

**Avoid:**
- ❌ Mandatory upgrade (semua optional)
- ❌ Trap upgrade (semua viable)
- ❌ Pay-to-win feel (semua earnable)
- ❌ Grind requirement (natural collection)

---

### 4.2 Sistem Save & Checkpoint

#### Auto-Save
- Setiap masuk dunia baru
- Setelah defeat boss
- Setiap 5 menit (background save)

#### Checkpoint
- Statue/bonfire di level
- Restore health ke full
- Respawn point jika mati
- Bisa fast travel antar checkpoint (setelah selesai dunia)

#### Save Slot
- 3 save slot berbeda
- Tampilkan: Dunia terakhir, playtime, completion %

### 4.3 Sistem Completion & Replay Value

#### Completion Tracking
- **Main Quest**: Selesaikan semua dunia (100% required)
- **Collectibles**: Kumpulkan semua crystal, heart, scroll (100%)
- **Lore**: Temukan semua tablet (100%)
- **No Death Run**: Selesaikan dunia tanpa mati (per dunia)
- **Speedrun**: Selesaikan dunia dalam waktu target (per dunia)

#### Reward Completion
- **50% Completion**: Unlock costume 1 (Fire Wizard)
- **75% Completion**: Unlock costume 2 (Lightning Mage)
- **100% Completion**: Unlock costume 3 (Wanderer), New Game+ mode
- **All No Death**: Unlock God Mode (infinite mana)
- **All Speedrun**: Unlock Time Attack mode

#### New Game+
- Mulai dari awal dengan semua upgrade
- Musuh lebih kuat (2x health, 1.5x damage)
- Unlock secret boss di setiap dunia
- Unlock true ending

---

## 🎨 FASE 5: Polish & Quality of Life

### 5.1 Visual Enhancement

#### Particle Effects
- **Combat**: Hit spark, slash effect, magic trail
- **Environment**: Falling leaves, dust particle, ambient fog
- **Special**: Boss aura, power-up glow, death explosion

#### Screen Effects
- **Hit Stop**: Freeze frame 0.1 detik saat hit musuh (game feel)
- **Screen Shake**: Saat boss attack atau player hit
- **Slow Motion**: Saat kill boss (dramatic effect)
- **Vignette**: Saat low health (visual warning)

#### Lighting
- **Dynamic Light**: Torch, magic spell, lightning
- **Ambient Light**: Per dunia punya mood lighting berbeda
- **Shadow**: Simple shadow untuk depth

### 5.2 Audio System

#### Music
- **Main Menu**: Calm, mysterious theme
- **Dunia 1-2**: Light, adventure music
- **Dunia 3-4**: Tense, mysterious music
- **Dunia 5-6**: Epic, intense battle music
- **Boss Fight**: Dynamic music (intensity naik per phase)

#### Sound Effects
- **Player**: Footstep, jump, attack swing, magic cast, hurt, death
- **Enemy**: Attack sound, hurt, death (per jenis musuh)
- **Environment**: Door open, chest open, switch activate, collectible pickup
- **UI**: Button click, menu navigate, pause

#### Voice (Optional)
- **Player**: Grunt saat attack/hurt (no dialog)
- **Boss**: Roar atau magic chant

### 5.3 UI/UX Improvement

#### HUD Enhancement
- **Mana Bar**: Tambah di bawah health bar
- **Skill Cooldown**: Icon skill dengan cooldown timer
- **Combo Counter**: Tampilkan combo hit (fade setelah 2 detik)
- **Damage Number**: Floating damage number saat hit musuh
- **Boss Health Bar**: Muncul di atas layar saat boss fight

#### Menu System
- **Main Menu**: New Game, Continue, Options, Quit
- **Pause Menu**: Resume, Options, Restart, Main Menu
- **Options**: 
  - Volume: Master, Music, SFX
  - Controls: Remap keys
  - Display: Fullscreen, Resolution, VSync
  - Gameplay: Damage numbers on/off, Screen shake intensity

#### Map System (Optional)
- **World Map**: Tampilkan progress dunia
- **Level Map**: Mini-map di corner (fog of war)
- **Fast Travel**: Unlock setelah selesai dunia

### 5.4 Tutorial & Onboarding

#### Tutorial Terintegrasi (Dunia 1)
- **Movement**: Pop-up saat pertama kali masuk
- **Combat**: Pop-up saat ketemu musuh pertama
- **Magic**: Pop-up saat unlock skill pertama
- **Interaction**: Pop-up saat ketemu kunci/peti pertama

#### Control Hints
- **Contextual**: Tampilkan hint sesuai situasi
  - "Press SPACE to jump" (dekat jurang)
  - "Press LEFT CLICK to attack" (dekat musuh)
  - "Press E to interact" (dekat chest)

#### Difficulty Assist (Optional)
- **Easy Mode**: 2x health, 0.75x enemy damage
- **Normal Mode**: Default
- **Hard Mode**: 0.75x health, 1.5x enemy damage, no checkpoint heal

---

## 🛠️ FASE 6: Technical Implementation Priority

### Priority 1 (Core Gameplay) - Minggu 1-2
1. ✅ Sistem mana & mana bar UI
2. ✅ Implementasi 3 magic skill dasar (1 per elemen)
3. ✅ Combo system (3-hit combo)
4. ✅ Skill cooldown system

### Priority 2 (Enemy Variety) - Minggu 3-4
1. ✅ Implementasi 3 musuh tier 1 (Bat, Crawler, Wisp)
2. ✅ Enemy AI behavior tree
3. ✅ Enemy spawn system
4. ✅ Drop system (mana potion)

### Priority 3 (Level Design) - Minggu 5-6
1. ✅ Design & build Dunia 2 (Mountain Pass)
2. ✅ Implementasi hazard baru (falling rocks, wind)
3. ✅ Checkpoint system
4. ✅ Collectible system (mana crystal)

### Priority 4 (Boss Fight) - Minggu 7-8
1. ✅ Implementasi mini-boss pertama (Ancient Treant)
2. ✅ Boss health bar UI
3. ✅ Phase transition system
4. ✅ Boss reward system

### Priority 5 (Progression) - Minggu 9-10
1. ✅ Skill tree UI
2. ✅ Upgrade system
3. ✅ Save/load system
4. ✅ World map & level select

### Priority 6 (Polish) - Minggu 11-12
1. ✅ Particle effects
2. ✅ Sound effects & music
3. ✅ Screen effects (shake, hit stop)
4. ✅ Menu polish & transitions

### Priority 7 (Content) - Minggu 13-16
1. ✅ Build Dunia 3-6
2. ✅ Implementasi semua musuh tier 2
3. ✅ Implementasi semua boss
4. ✅ Secret areas & collectibles

### Priority 8 (Final Polish) - Minggu 17-18
1. ✅ Playtesting & balancing
2. ✅ Bug fixing
3. ✅ Performance optimization
4. ✅ Final content check

---

## 📈 Metrics & Balancing

### Combat Balance

#### Player Stats (Base)
```
Health: 5 hearts (10 dengan upgrade)
Mana: 100 (140 dengan upgrade)
Damage: 1 per hit (1.5 dengan upgrade)
Attack Speed: 1 hit per 0.5 detik
Movement Speed: 150 (walk), 250 (run)
```

#### Enemy Stats Reference
```
Tier 1 (Dunia 1-2):
- Health: 1-3 hit
- Damage: 0.5-1 heart
- Speed: 50-100

Tier 2 (Dunia 3-4):
- Health: 3-5 hit
- Damage: 1-1.5 heart
- Speed: 75-125

Tier 3 (Dunia 5-6):
- Health: 5-8 hit
- Damage: 1.5-2 heart
- Speed: 100-150
```

#### Boss Stats Reference
```
Mini-Boss:
- Health: 50-80 hit
- Damage: 1-2 heart per attack
- Phase: 2-3 phase

Final Boss:
- Health: 150 hit
- Damage: 2-3 heart per attack
- Phase: 4 phase
```

### Difficulty Curve
```
Dunia 1: Tutorial (Difficulty 1/10)
Dunia 2: Easy (Difficulty 3/10)
Dunia 3: Medium (Difficulty 5/10)
Dunia 4: Medium-Hard (Difficulty 7/10)
Dunia 5: Hard (Difficulty 8/10)
Dunia 6: Very Hard (Difficulty 10/10)
```

---

## 🎯 Success Metrics

### Player Engagement
- **Target Completion Rate**: 70% player selesaikan Dunia 1
- **Target Retention**: 50% player lanjut ke Dunia 3
- **Target Full Completion**: 20% player selesaikan semua dunia

### Gameplay Metrics
- **Average Playtime**: 60-90 menit (first playthrough)
- **Death Rate**: 3-5 death per dunia (normal mode)
- **Collectible Rate**: 60% player kumpulkan 50%+ collectibles

### Quality Metrics
- **Bug Rate**: <5 critical bugs per 100 playthrough
- **Performance**: Maintain 60 FPS di hardware target
- **Load Time**: <3 detik per level transition

---

## 🚦 Roadmap Summary

### Version 0.2 (Current → +2 bulan)
- ✅ Sistem magic & combo
- ✅ 3 musuh baru
- ✅ Dunia 2 complete
- ✅ Mini-boss pertama
- ✅ Basic progression system

### Version 0.5 (Beta - +4 bulan)
- ✅ 4 dunia complete (1-4)
- ✅ Semua musuh tier 1-2
- ✅ 2 mini-boss
- ✅ Full skill tree
- ✅ Save system
- ✅ Audio implementation

### Version 1.0 (Release - +6 bulan)
- ✅ 6 dunia complete
- ✅ Semua musuh & boss
- ✅ Full polish (VFX, SFX, UI)
- ✅ Secret content
- ✅ New Game+
- ✅ Achievement system

### Post-Launch (Optional)
- 🎁 DLC: Dunia 7-8 (extra content)
- 🎁 Boss Rush mode
- 🎁 Endless mode (wave survival)
- 🎁 Multiplayer co-op (ambitious)

---

## 💡 Tips Implementasi

### Untuk Sistem Combat
1. **Mulai dari feel**: Pastikan serangan terasa "memuaskan" (hit stop, screen shake, particle)
2. **Balancing iteratif**: Playtest terus, adjust damage/cooldown
3. **Visual clarity**: Player harus jelas lihat attack range & timing

### Untuk Enemy Design
1. **Telegraphing**: Musuh harus kasih warning sebelum attack (animation, sound, particle)
2. **Counterplay**: Setiap musuh harus punya weakness yang jelas
3. **Variety**: Mix musuh dengan behavior berbeda di satu area

### Untuk Level Design
1. **Pacing**: Selingi combat dengan platforming & puzzle
2. **Risk-reward**: Taruh collectible di tempat berbahaya (optional challenge)
3. **Landmark**: Setiap area punya visual landmark yang memorable

### Untuk Boss Fight
1. **Phase transition**: Kasih breathing room (cutscene singkat, invulnerable moment)
2. **Pattern variety**: Jangan spam attack yang sama
3. **Fairness**: Boss attack harus bisa di-dodge dengan skill, bukan luck

---

## 📝 Catatan Penutup

Dokumen ini adalah **roadmap komprehensif** untuk mengembangkan "The Witch" menjadi game platformer yang engaging dengan durasi 1+ jam gameplay. 

### Fokus Utama:
1. **Combat yang memuaskan** dengan variasi magic & combo
2. **Enemy variety** yang menantang tapi fair
3. **Level design** yang indah dan fun untuk dieksplorasi
4. **Progression system** yang rewarding

### Saran Prioritas:
- **Fase 1-2** (Combat & Enemy) adalah **MUST HAVE** - ini yang bikin game fun
- **Fase 3-4** (Level & Boss) adalah **core content** - ini yang bikin game panjang
- **Fase 5-6** (Polish & Technical) adalah **quality** - ini yang bikin game profesional

### Fleksibilitas:
- Semua angka (damage, health, durasi) bisa di-adjust saat playtesting
- Fitur bisa di-cut jika waktu terbatas (prioritaskan yang penting)
- Bisa tambah fitur baru sesuai feedback player

**Semangat develop! 🚀✨**

---

*Dokumen ini dibuat berdasarkan analisis game "The Witch" versi current dan disesuaikan dengan visi: game casual santai dengan fokus pemandangan & combat seimbang, target 1+ jam gameplay untuk remaja ke atas.*
