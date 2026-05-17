extends TextureButton

func _ready() -> void:
	# Pastikan node parent paling atas (MainMenu) tetap aktif saat game di-pause
	var main_menu = get_parent().get_parent()
	main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Menu disembunyikan saat game baru mulai
	main_menu.visible = false
	
	# Hubungkan event saat tombol diklik
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var main_menu = get_parent().get_parent()
	main_menu.visible = false
	get_tree().paused = false
	
	# Jika player sudah mati, tampilkan game over setelah menu ditutup
	var game_over = get_tree().root.find_child("GameOver", true, false)
	if game_over and game_over.has_method("try_show_game_over"):
		game_over.try_show_game_over()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		var main_menu = get_parent().get_parent()
		
		# Jika sedang pause dan menu ini tampil, maka unpause
		if get_tree().paused and main_menu.visible:
			main_menu.visible = false
			get_tree().paused = false
			
			# Jika player sudah mati, tampilkan game over setelah menu ditutup
			var game_over = get_tree().root.find_child("GameOver", true, false)
			if game_over and game_over.has_method("try_show_game_over"):
				game_over.try_show_game_over()
		# Jika tidak sedang pause, maka pause game dan tampilkan menu
		elif not get_tree().paused:
			main_menu.visible = true
			get_tree().paused = true