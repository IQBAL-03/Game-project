extends Control

func _ready():
	var texture_rect = $TextureRect
	var screen_size = get_viewport_rect().size
	var tr_size = texture_rect.size
	var scale_factor = min(screen_size.x / tr_size.x, screen_size.y / tr_size.y)
	texture_rect.scale = Vector2(scale_factor, scale_factor)
	texture_rect.position = (screen_size - (tr_size * scale_factor)) / 2.0
	
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
	# Exit game completely just like the original main_menu.tscn
	get_tree().quit()
