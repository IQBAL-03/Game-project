extends TextureButton

func _ready() -> void:
	# Hubungkan event klik ke fungsi di bawah
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Cari node MainMenu. Karena resume.gd pakai get_parent().get_parent(), 
	# kita asumsikan struktur node-nya sama (MainMenu -> TextureRect -> X_Button)
	var main_menu = get_parent().get_parent()
	
	# Sembunyikan menu dan unpause game
	if main_menu is Control:
		main_menu.visible = false
	else:
		# Fallback kalau node parent langsungnya yang Control
		get_parent().visible = false
		
	get_tree().paused = false
	
	# Jika player sudah mati, tampilkan game over setelah menu ditutup
	var game_over = get_tree().root.find_child("GameOver", true, false)
	if game_over and game_over.has_method("try_show_game_over"):
		game_over.try_show_game_over()
