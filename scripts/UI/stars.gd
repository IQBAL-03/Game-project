extends Control

func _ready() -> void:
	ButtonHover.apply_to_tree(self)
	
	var texture_rect = get_node_or_null("TextureRect")
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
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Menu/level.tscn")

func _on_again_pressed() -> void:
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Worlds/dunia_1.tscn")

func _on_quit_pressed() -> void:
	LevelTracker.reset()
	get_tree().change_scene_to_file("res://scenes/Menu/level.tscn")
