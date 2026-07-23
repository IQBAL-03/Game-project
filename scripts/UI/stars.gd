extends CanvasLayer

func _ready() -> void:
	# Set process mode agar UI tetap bisa diklik saat game paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Set layer tinggi agar muncul di atas semua
	layer = 100
	
	# Sembunyikan player setelah process mode diset
	_hide_player()
	
	ButtonHover.apply_to_tree(self)
	
	var control = get_node_or_null("Control")
	if not control:
		return
		
	var texture_rect = control.get_node_or_null("TextureRect")
	if texture_rect:
		var x_button = texture_rect.get_node_or_null("x")
		if x_button:
			if x_button.pressed.is_connected(_on_x_pressed):
				x_button.pressed.disconnect(_on_x_pressed)
			x_button.pressed.connect(_on_x_pressed)
		
		var again_button = texture_rect.get_node_or_null("again")
		if again_button:
			if again_button.pressed.is_connected(_on_again_pressed):
				again_button.pressed.disconnect(_on_again_pressed)
			again_button.pressed.connect(_on_again_pressed)
		
		var quit_button = texture_rect.get_node_or_null("quit")
		if quit_button:
			if quit_button.pressed.is_connected(_on_quit_pressed):
				quit_button.pressed.disconnect(_on_quit_pressed)
			quit_button.pressed.connect(_on_quit_pressed)
		
		var next_button = texture_rect.get_node_or_null("next")
		if next_button:
			next_button.visible = false

func _on_x_pressed() -> void:
	_unpause_and_remove()
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Menu/level.tscn")

func _on_again_pressed() -> void:
	_unpause_and_remove()
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Worlds/dunia_1.tscn")

func _on_quit_pressed() -> void:
	_unpause_and_remove()
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Menu/level.tscn")

func _hide_player() -> void:
	# Cari player di scene tree
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.visible = false
		# Pastikan semua child sprite player juga tersembunyi
		for child in player.get_children():
			if child is AnimatedSprite2D or child is Sprite2D:
				child.visible = false

func _unpause_and_remove() -> void:
	# Tampilkan player kembali sebelum unpause
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.visible = true
		# Pastikan semua child sprite player juga ditampilkan
		for child in player.get_children():
			if child is AnimatedSprite2D or child is Sprite2D:
				child.visible = true
	
	# Unpause game sebelum pindah scene
	get_tree().paused = false
	# Hapus overlay dari scene tree
	queue_free()
