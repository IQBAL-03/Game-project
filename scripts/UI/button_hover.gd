extends Node

func apply_to_tree(root: Node) -> void:
	for child in root.find_children("*", "TextureButton", true, false):
		if child is TextureButton:
			apply_to_button(child)

func apply_to_button(button: TextureButton) -> void:
	if not button.mouse_entered.is_connected(_on_mouse_entered):
		button.mouse_entered.connect(_on_mouse_entered.bind(button))
	if not button.mouse_exited.is_connected(_on_mouse_exited):
		button.mouse_exited.connect(_on_mouse_exited.bind(button))

func _on_mouse_entered(button: TextureButton) -> void:
	button.modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_mouse_exited(button: TextureButton) -> void:
	button.modulate = Color(1.0, 1.0, 1.0, 1.0)
