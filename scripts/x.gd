extends TextureButton

func _ready() -> void:

	pressed.connect(_on_pressed)

func _on_pressed() -> void:


	var main_menu = get_parent().get_parent()


	if main_menu is Control:
		main_menu.visible = false
	else:

		get_parent().visible = false

	get_tree().paused = false


	var game_over = get_tree().root.find_child("GameOver", true, false)
	if game_over and game_over.has_method("try_show_game_over"):
		game_over.try_show_game_over()
