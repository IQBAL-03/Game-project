extends Control

func _ready():
	# Load dan putar musik home di runtime
	var home_music = load("res://Backsound/Home/Home-and-Level.mp3")
	if home_music:
		MusicManager.play_music(home_music, true)
	else:
		push_error("Failed to load Home-and-Level.mp3")
	
	var texture_rect = $TextureRect
	var screen_size = get_viewport_rect().size
	var tr_size = texture_rect.size
	var scale_factor = min(screen_size.x / tr_size.x, screen_size.y / tr_size.y)
	texture_rect.scale = Vector2(scale_factor, scale_factor)
	texture_rect.position = (screen_size - (tr_size * scale_factor)) / 2.0
	
	_update_stars()
	
	if ButtonHover:
		ButtonHover.apply_to_tree(self)

	if has_node("TextureRect/open"):
		$TextureRect/open.hide()
		$TextureRect/open.disabled = true
	if has_node("TextureRect/level_1"):
		$TextureRect/level_1.show()
		$TextureRect/level_1.disabled = false
		if not $TextureRect/level_1.pressed.is_connected(_on_level_1_pressed):
			$TextureRect/level_1.pressed.connect(_on_level_1_pressed)
			
	if has_node("TextureRect/open") and not $TextureRect/open.pressed.is_connected(_on_open_pressed):
		$TextureRect/open.pressed.connect(_on_open_pressed)
	
	for i in range(2, 10):
		var lvl = get_node_or_null("TextureRect/level_" + str(i))
		if lvl:
			lvl.hide()
			lvl.disabled = true
		
		var terkunci = get_node_or_null("TextureRect/level_terkunci_" + str(i))
		if terkunci:
			terkunci.show()
			terkunci.disabled = true
			
		var gembok = get_node_or_null("TextureRect/gembok_" + str(i))
		if gembok:
			gembok.show()
			gembok.disabled = true
	
	if has_node("TextureRect/quit"):
		var quit_btn = $TextureRect/quit
		for conn in quit_btn.pressed.get_connections():
			quit_btn.pressed.disconnect(conn.callable)
		quit_btn.pressed.connect(_on_quit_pressed)
			
	if has_node("TextureRect/x"):
		var x_btn = $TextureRect/x
		for conn in x_btn.pressed.get_connections():
			x_btn.pressed.disconnect(conn.callable)
		x_btn.pressed.connect(_on_quit_pressed)

func _update_stars() -> void:
	var stars = LevelTracker.get_level_stars(1)
	
	var s1 = get_node_or_null("TextureRect/stars_1")
	var s2 = get_node_or_null("TextureRect/stars_2")
	var s3 = get_node_or_null("TextureRect/stars_3")
	
	var es1 = get_node_or_null("TextureRect/empty_stars_1")
	var es2 = get_node_or_null("TextureRect/empty_stars_2")
	var es3 = get_node_or_null("TextureRect/empty_stars_3")
	
	if stars == 0:
		# Hide all stars if level has not been completed yet
		if s1: s1.visible = false
		if s2: s2.visible = false
		if s3: s3.visible = false
		if es1: es1.visible = false
		if es2: es2.visible = false
		if es3: es3.visible = false
	else:
		if s1: s1.visible = (stars >= 1)
		if es1: es1.visible = (stars < 1)
		
		if s2: s2.visible = (stars >= 2)
		if es2: es2.visible = (stars < 2)
		
		if s3: s3.visible = (stars >= 3)
		if es3: es3.visible = (stars < 3)

func _on_level_1_pressed():
	if has_node("TextureRect/level_1"):
		$TextureRect/level_1.hide()
		$TextureRect/level_1.set_deferred("disabled", true)
	if has_node("TextureRect/open"):
		$TextureRect/open.show()
		$TextureRect/open.modulate = Color(1.3, 1.3, 1.3) # Brighten to make it obvious
		
		# Enable it immediately on the next frame to prevent same-frame double click but avoid lag
		$TextureRect/open.set_deferred("disabled", false)

var dunia_1_scene = preload("res://scenes/Worlds/dunia_1.tscn")

func _on_open_pressed():
	get_tree().change_scene_to_packed(dunia_1_scene)

func _on_quit_pressed():
	# Play button click sound
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load("res://Backsound/button-click.mp3")
	sound_player.bus = "SFX"
	add_child(sound_player)
	sound_player.play()
	
	# Wait for sound to finish before changing scene
	await sound_player.finished
	sound_player.queue_free()
	
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
