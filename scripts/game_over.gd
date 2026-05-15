extends Control

var is_game_over_pending = false

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 100
	z_as_relative = false
	
	# Tunggu frame pertama agar player selesai di-load
	await get_tree().process_frame
	_connect_to_player()

func _connect_to_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var health_component = player.get_node_or_null("HealthComponent")
		if health_component:
			health_component.died.connect(_on_player_died)

func _on_player_died() -> void:
	# Tunggu 1.5 detik agar animasi death/mati selesai diputar
	await get_tree().create_timer(1.5).timeout
	is_game_over_pending = true
	try_show_game_over()

func try_show_game_over() -> void:
	if not is_game_over_pending:
		return
		
	# Cari MainMenu (Pause Menu)
	var main_menu = get_tree().root.find_child("MainMenu", true, false)
	
	# Jika MainMenu sedang tampil, jangan tampilkan Game Over dulu
	if main_menu and main_menu.visible:
		return
		
	visible = true
	# Pause game agar player tidak bisa bergerak saat layar game over muncul
	get_tree().paused = true
	is_game_over_pending = false

func _input(event: InputEvent) -> void:
	# Jika layar game over sedang tampil dan player menekan Enter/Space (ui_accept)
	if visible and event.is_action_pressed("ui_accept"):
		# Matikan pause dan restart scene
		get_tree().paused = false
		get_tree().reload_current_scene()
