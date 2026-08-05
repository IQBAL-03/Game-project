extends Node

func _ready():
	# Hentikan AudioStreamPlayer lokal jika ada
	if has_node("BgMusic"):
		var local_player = get_node("BgMusic")
		local_player.stop()
		local_player.queue_free()
	
	# Load musik home di runtime (bukan preload)
	var home_music = load("res://Backsound/Home/Home-and-Level.mp3")
	
	# Putar musik home melalui MusicManager (singleton)
	# Jika musik sudah diputar dari sebelumnya, tidak akan mengulang dari awal
	if home_music:
		MusicManager.play_music(home_music, true)
	else:
		push_error("Failed to load Home-and-Level.mp3")
