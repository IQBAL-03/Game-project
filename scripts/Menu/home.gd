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
	
	if ButtonHover:
		ButtonHover.apply_to_tree(self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_settings()
		get_viewport().set_input_as_handled()

func _toggle_settings() -> void:
	var existing = get_tree().root.find_child("Settings", true, false)
	if existing:
		# Settings sudah terbuka — ESC akan ditangani oleh settings_menu.gd itu sendiri
		return
	var settings_scene = preload("res://scenes/Menu/settings.tscn").instantiate()
	get_tree().root.add_child(settings_scene)
