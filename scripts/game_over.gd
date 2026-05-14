extends Control

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
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
	visible = true
	# Pause game agar player tidak bisa bergerak saat layar game over muncul
	get_tree().paused = true
