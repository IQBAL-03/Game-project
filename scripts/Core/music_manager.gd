extends Node

# AudioStreamPlayer untuk background music
var music_player: AudioStreamPlayer = null
var current_music: AudioStream = null

func _ready():
	ensure_audio_buses()
	# Buat AudioStreamPlayer
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Set process mode agar tidak terhenti saat game pause
	process_mode = Node.PROCESS_MODE_ALWAYS

func ensure_audio_buses() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		var bus_idx = AudioServer.bus_count
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, "Music")
		AudioServer.set_bus_send(bus_idx, "Master")
	if AudioServer.get_bus_index("SFX") == -1:
		var bus_idx = AudioServer.bus_count
		AudioServer.add_bus(bus_idx)
		AudioServer.set_bus_name(bus_idx, "SFX")
		AudioServer.set_bus_send(bus_idx, "Master")

func play_music(music: AudioStream, _loop: bool = true):
	"""
	Memutar musik. Jika musik yang sama sudah diputar, tidak akan mengulang dari awal.
	Parameter _loop tidak digunakan karena looping diatur di properties AudioStream itu sendiri.
	"""
	# Jika musik yang diminta sama dengan yang sedang diputar dan sedang berjalan
	if current_music == music and music_player.playing:
		return  # Tidak perlu melakukan apa-apa, musik sudah berjalan
	
	# Jika musik berbeda, ganti musik
	current_music = music
	music_player.stream = music
	music_player.play()

func stop_music():
	"""
	Menghentikan musik yang sedang diputar
	"""
	music_player.stop()
	current_music = null

func pause_music():
	"""
	Menjeda musik
	"""
	music_player.stream_paused = true

func resume_music():
	"""
	Melanjutkan musik yang dijeda
	"""
	music_player.stream_paused = false

func set_volume_db(volume_db: float):
	"""
	Mengatur volume musik dalam decibel
	"""
	music_player.volume_db = volume_db

func is_playing() -> bool:
	"""
	Mengecek apakah musik sedang diputar
	"""
	return music_player.playing
