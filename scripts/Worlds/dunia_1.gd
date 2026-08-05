extends Node2D

func _ready():
	# Hentikan musik menu saat masuk ke level/world
	MusicManager.stop_music()
