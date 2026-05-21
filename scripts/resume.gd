extends TextureButton

func _ready() -> void:

	var main_menu = get_parent().get_parent()
	main_menu.process_mode = Node.PROCESS_MODE_ALWAYS


	main_menu.visible = false


	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var main_menu = get_parent().get_parent()
	main_menu.visible = false
	get_tree().paused = false


	var game_over = get_tree().root.find_child("GameOver", true, false)
	if game_over and game_over.has_method("try_show_game_over"):
		game_over.try_show_game_over()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		var main_menu = get_parent().get_parent()


		if get_tree().paused and main_menu.visible:
			main_menu.visible = false
			get_tree().paused = false


			var game_over = get_tree().root.find_child("GameOver", true, false)
			if game_over and game_over.has_method("try_show_game_over"):
				game_over.try_show_game_over()

		elif not get_tree().paused:
			main_menu.visible = true
			get_tree().paused = true