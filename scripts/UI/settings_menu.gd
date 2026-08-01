extends CanvasLayer

# Volume levels range 0 to 15
var audio_level: int = 15
var music_level: int = 15
var is_audio_muted: bool = false
var is_music_muted: bool = false
var is_fullscreen: bool = false

# Backup values for Decline functionality
var initial_audio_level: int = 15
var initial_music_level: int = 15
var initial_audio_muted: bool = false
var initial_music_muted: bool = false
var initial_fullscreen: bool = false

@onready var texture_rect = $TextureRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	get_tree().paused = true
	
	# Make sure music continues playing when game is paused
	_ensure_bg_music_process_mode()
	
	_load_settings()
	_backup_settings()
	_setup_connections()
	_apply_audio_volume()
	_apply_music_volume()
	_update_ui()
	if Engine.has_singleton("ButtonHover") or ButtonHover != null:
		ButtonHover.apply_to_tree(self)

func _ensure_bg_music_process_mode() -> void:
	var bg_music = get_tree().root.find_child("BgMusic", true, false)
	if bg_music:
		bg_music.process_mode = Node.PROCESS_MODE_ALWAYS

func _setup_connections() -> void:
	if not texture_rect:
		return

	# Close button
	var btn_x = texture_rect.get_node_or_null("x")
	if btn_x and not btn_x.pressed.is_connected(_on_close_pressed):
		btn_x.pressed.connect(_on_close_pressed)

	# Audio Mute buttons
	var audio_logo = texture_rect.get_node_or_null("AudioLogo")
	var audio_logo_empty = texture_rect.get_node_or_null("AudioLogoEmpty")
	if audio_logo and not audio_logo.pressed.is_connected(_toggle_audio_mute):
		audio_logo.pressed.connect(_toggle_audio_mute)
	if audio_logo_empty and not audio_logo_empty.pressed.is_connected(_toggle_audio_mute):
		audio_logo_empty.pressed.connect(_toggle_audio_mute)

	# Music Mute buttons
	var music_icon = texture_rect.get_node_or_null("MusicIcon")
	var music_icon_empty = texture_rect.get_node_or_null("MusicIconEmpty")
	if music_icon and not music_icon.pressed.is_connected(_toggle_music_mute):
		music_icon.pressed.connect(_toggle_music_mute)
	if music_icon_empty and not music_icon_empty.pressed.is_connected(_toggle_music_mute):
		music_icon_empty.pressed.connect(_toggle_music_mute)

	# Fullscreen & Window buttons
	var btn_fullscreen = texture_rect.get_node_or_null("FullScreen")
	var btn_fullscreen_empty = texture_rect.get_node_or_null("FullScreenEmpty")
	if btn_fullscreen and not btn_fullscreen.pressed.is_connected(set_fullscreen.bind(true)):
		btn_fullscreen.pressed.connect(set_fullscreen.bind(true))
	if btn_fullscreen_empty and not btn_fullscreen_empty.pressed.is_connected(set_fullscreen.bind(true)):
		btn_fullscreen_empty.pressed.connect(set_fullscreen.bind(true))

	var btn_window = texture_rect.get_node_or_null("Window")
	var btn_window_empty = texture_rect.get_node_or_null("WindowEmpty")
	if btn_window and not btn_window.pressed.is_connected(set_fullscreen.bind(false)):
		btn_window.pressed.connect(set_fullscreen.bind(false))
	if btn_window_empty and not btn_window_empty.pressed.is_connected(set_fullscreen.bind(false)):
		btn_window_empty.pressed.connect(set_fullscreen.bind(false))

	# Save & Decline buttons
	var btn_save = texture_rect.get_node_or_null("Save")
	if btn_save and not btn_save.pressed.is_connected(_on_save_pressed):
		btn_save.pressed.connect(_on_save_pressed)

	var btn_decline = texture_rect.get_node_or_null("Decline")
	if btn_decline and not btn_decline.pressed.is_connected(_on_decline_pressed):
		btn_decline.pressed.connect(_on_decline_pressed)

	# Connect Audio and Music bars 1..15
	for i in range(1, 16):
		var a_empty = texture_rect.get_node_or_null("Audio_Bar_Empty_" + str(i))
		var a_active = texture_rect.get_node_or_null("Audio_Bar_Active_" + str(i))
		if a_empty and not a_empty.pressed.is_connected(_set_audio_level.bind(i)):
			a_empty.pressed.connect(_set_audio_level.bind(i))
		if a_active and not a_active.pressed.is_connected(_set_audio_level.bind(i)):
			a_active.pressed.connect(_set_audio_level.bind(i))

		var m_empty = texture_rect.get_node_or_null("Music_Bar_Empty_" + str(i))
		var m_active = texture_rect.get_node_or_null("Music_Bar_Active_" + str(i))
		if m_empty and not m_empty.pressed.is_connected(_set_music_level.bind(i)):
			m_empty.pressed.connect(_set_music_level.bind(i))
		if m_active and not m_active.pressed.is_connected(_set_music_level.bind(i)):
			m_active.pressed.connect(_set_music_level.bind(i))

func _set_audio_level(level: int) -> void:
	if audio_level == level and level == 1:
		audio_level = 0
	else:
		audio_level = level
	if audio_level > 0:
		is_audio_muted = false
	_apply_audio_volume()
	_update_ui()

func _set_music_level(level: int) -> void:
	if music_level == level and level == 1:
		music_level = 0
	else:
		music_level = level
	if music_level > 0:
		is_music_muted = false
	_apply_music_volume()
	_update_ui()

func _toggle_audio_mute() -> void:
	is_audio_muted = !is_audio_muted
	_apply_audio_volume()
	_update_ui()

func _toggle_music_mute() -> void:
	is_music_muted = !is_music_muted
	_apply_music_volume()
	_update_ui()

func set_fullscreen(enable: bool) -> void:
	is_fullscreen = enable
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		var screen_size = DisplayServer.screen_get_size()
		var window_size = Vector2i(1280, 720)
		DisplayServer.window_set_size(window_size)
		var center_pos = Vector2i((screen_size.x - window_size.x) / 2, (screen_size.y - window_size.y) / 2)
		DisplayServer.window_set_position(center_pos)
	_update_ui()

func _apply_audio_volume() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if is_audio_muted or audio_level == 0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		var ratio = float(audio_level) / 15.0
		var db = linear_to_db(ratio)
		AudioServer.set_bus_volume_db(bus_idx, db)

func _apply_music_volume() -> void:
	var music_bus_idx = AudioServer.get_bus_index("Music")
	if music_bus_idx != -1:
		if is_music_muted or music_level == 0:
			AudioServer.set_bus_mute(music_bus_idx, true)
		else:
			AudioServer.set_bus_mute(music_bus_idx, false)
			var ratio = float(music_level) / 15.0
			var db = linear_to_db(ratio)
			AudioServer.set_bus_volume_db(music_bus_idx, db)
	
	var bg_music = get_tree().root.find_child("BgMusic", true, false)
	if bg_music and bg_music is AudioStreamPlayer:
		bg_music.process_mode = Node.PROCESS_MODE_ALWAYS
		if is_music_muted or music_level == 0:
			bg_music.volume_db = -80.0
		else:
			bg_music.volume_db = linear_to_db(float(music_level) / 15.0)

func _update_ui() -> void:
	if not texture_rect:
		return

	# Update Audio Bars
	for i in range(1, 16):
		var a_act = texture_rect.get_node_or_null("Audio_Bar_Active_" + str(i))
		if a_act:
			a_act.visible = (not is_audio_muted) and (i <= audio_level)

	# Update Music Bars
	for i in range(1, 16):
		var m_act = texture_rect.get_node_or_null("Music_Bar_Active_" + str(i))
		if m_act:
			m_act.visible = (not is_music_muted) and (i <= music_level)

	# Audio Mute icons
	var audio_logo = texture_rect.get_node_or_null("AudioLogo")
	var audio_logo_empty = texture_rect.get_node_or_null("AudioLogoEmpty")
	if audio_logo:
		audio_logo.visible = not is_audio_muted
	if audio_logo_empty:
		audio_logo_empty.visible = is_audio_muted

	# Music Mute icons
	var music_icon = texture_rect.get_node_or_null("MusicIcon")
	var music_icon_empty = texture_rect.get_node_or_null("MusicIconEmpty")
	if music_icon:
		music_icon.visible = not is_music_muted
	if music_icon_empty:
		music_icon_empty.visible = is_music_muted

	# Fullscreen & Window icons
	var fs = texture_rect.get_node_or_null("FullScreen")
	var fs_emp = texture_rect.get_node_or_null("FullScreenEmpty")
	var win = texture_rect.get_node_or_null("Window")
	var win_emp = texture_rect.get_node_or_null("WindowEmpty")

	var current_mode = DisplayServer.window_get_mode()
	var mode_is_fs = (current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	if fs:
		fs.visible = mode_is_fs
	if fs_emp:
		fs_emp.visible = not mode_is_fs
	if win:
		win.visible = not mode_is_fs
	if win_emp:
		win_emp.visible = mode_is_fs

func _backup_settings() -> void:
	initial_audio_level = audio_level
	initial_music_level = music_level
	initial_audio_muted = is_audio_muted
	initial_music_muted = is_music_muted
	initial_fullscreen = is_fullscreen

func _on_save_pressed() -> void:
	_save_settings()
	_backup_settings()
	_close()

func _on_decline_pressed() -> void:
	audio_level = initial_audio_level
	music_level = initial_music_level
	is_audio_muted = initial_audio_muted
	is_music_muted = initial_music_muted
	set_fullscreen(initial_fullscreen)
	_apply_audio_volume()
	_apply_music_volume()
	_close()

func _on_close_pressed() -> void:
	_close()

func _close() -> void:
	get_tree().paused = false
	visible = false
	queue_free()

func _save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "audio_level", audio_level)
	config.set_value("audio", "music_level", music_level)
	config.set_value("audio", "is_audio_muted", is_audio_muted)
	config.set_value("audio", "is_music_muted", is_music_muted)
	config.set_value("video", "fullscreen", is_fullscreen)
	config.save("user://settings.cfg")

func _load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		audio_level = config.get_value("audio", "audio_level", 15)
		music_level = config.get_value("audio", "music_level", 15)
		is_audio_muted = config.get_value("audio", "is_audio_muted", false)
		is_music_muted = config.get_value("audio", "is_music_muted", false)
		is_fullscreen = config.get_value("video", "fullscreen", false)
	else:
		var current_mode = DisplayServer.window_get_mode()
		is_fullscreen = (current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
