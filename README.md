# Game Project
![Godot](https://img.shields.io/badge/Godot-4.6.1-green) ![License](https://img.shields.io/badge/License-MIT-yellow)


Proyek game platformer sederhana yang dikembangkan menggunakan Godot Engine.

## Informasi Versi
- **Godot Version:** 4.6.1.stable

## Fitur Utama

### 1. Sistem Player
- **Pergerakan Dinamis**:
  - Berjalan dan Berlari (*double-tap* pada tombol arah untuk lari).
  - Loncat dan *Double Jump*.
- **Sistem Pertarungan**:
  - Klik kiri untuk menyerang musuh.
  - *AttackBox* yang aktif secara sinkron dengan animasi serangan.
- **Visual & Animasi**:
  - State animasi lengkap: Idle, Jalan, Lari, Lompat, dan Serang.
  - Penyesuaian arah hadap (*flip*) otomatis.

### 2. Mekanik Game
- **Sistem Kunci & Peti**:
  - Pemain dapat mengambil kunci (kapasitas 1 kunci).
  - Peti dapat dibuka menggunakan kunci yang dibawa.
  - Animasi peti berhenti pada frame tertentu saat terbuka.
- **Interaksi Objek**:
  - Kunci akan menghilang atau berpindah setelah digunakan.

### 3. Musuh (Predator Plant)
- **AI Sederhana**:
  - Pendeteksian pemain dalam radius tertentu.
  - Serangan otomatis jika pemain berada dalam jangkauan.
- **Sistem Kematian**:
  - Musuh dapat dikalahkan dengan serangan pemain.
  - Animasi kematian yang sinkron sebelum objek dihapus dari game.


## Cara Instalasi & Menjalankan Project

### 1. Clone Repositori
Clone proyek ini ke penyimpanan lokal Anda menggunakan Git:
```bash
git clone https://github.com/IQBAL-03/The-Witch-Project.git
```

### 2. Persiapan Godot Engine
Pastikan Anda sudah menginstal **Godot Engine version 4.6.1** atau yang terbaru. Jika belum, Anda bisa mengunduhnya di [godotengine.org](https://godotengine.org/).

### 3. Membuka Project
1. Buka **Godot Engine**.
2. Klik tombol **Import**.
3. Navigasikan ke dalam folder hasil clone tadi dan pilih file `project.godot`.
4. Klik **Import & Edit**.

### 4. Menjalankan Game
Tekan tombol **F5** atau klik tombol **Play** di pojok kanan atas editor Godot untuk menjalankan game.

