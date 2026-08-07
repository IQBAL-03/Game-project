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
	
	# Terapkan pengaturan yang tersimpan agar volume berlaku sejak awal game
	apply_saved_settings()

func apply_saved_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	var audio_level: int = 15
	var music_level: int = 15
	var is_audio_muted: bool = false
	var is_music_muted: bool = false
	
	if err == OK:
		audio_level = config.get_value("audio", "audio_level", 15)
		music_level = config.get_value("audio", "music_level", 15)
		is_audio_muted = config.get_value("audio", "is_audio_muted", false)
		is_music_muted = config.get_value("audio", "is_music_muted", false)
	
	# Terapkan SFX bus
	var sfx_idx = AudioServer.get_bus_index("SFX")
	if sfx_idx != -1:
		if is_audio_muted or audio_level == 0:
			AudioServer.set_bus_mute(sfx_idx, true)
		else:
			AudioServer.set_bus_mute(sfx_idx, false)
			AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(float(audio_level) / 15.0))
	
	# Terapkan Music bus
	var music_idx = AudioServer.get_bus_index("Music")
	if music_idx != -1:
		if is_music_muted or music_level == 0:
			AudioServer.set_bus_mute(music_idx, true)
		else:
			AudioServer.set_bus_mute(music_idx, false)
			AudioServer.set_bus_volume_db(music_idx, linear_to_db(float(music_level) / 15.0))

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
