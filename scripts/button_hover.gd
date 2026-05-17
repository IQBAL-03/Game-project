class_name ButtonHover
extends RefCounted

const COLOR_NORMAL := Color(1, 1, 1, 1)
const COLOR_HOVER := Color(0.72, 0.72, 0.72, 1)
const COLOR_PRESSED := Color(0.55, 0.55, 0.55, 1)


static func apply_to(button: BaseButton) -> void:
	if button.has_meta(&"button_hover_applied"):
		return
	button.set_meta(&"button_hover_applied", true)

	button.mouse_entered.connect(_on_mouse_entered.bind(button))
	button.mouse_exited.connect(_on_mouse_exited.bind(button))
	button.button_down.connect(_on_button_down.bind(button))
	button.button_up.connect(_on_button_up.bind(button))
	button.modulate = COLOR_NORMAL


static func apply_to_tree(root: Node) -> void:
	var stack: Array[Node] = [root]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node is TextureButton:
			apply_to(node)
		for child in node.get_children():
			stack.append(child)


static func _on_mouse_entered(button: BaseButton) -> void:
	if not button.disabled:
		button.modulate = COLOR_HOVER


static func _on_mouse_exited(button: BaseButton) -> void:
	button.modulate = COLOR_NORMAL


static func _on_button_down(button: BaseButton) -> void:
	if not button.disabled:
		button.modulate = COLOR_PRESSED


static func _on_button_up(button: BaseButton) -> void:
	if button.disabled:
		button.modulate = COLOR_NORMAL
	elif button.is_hovered():
		button.modulate = COLOR_HOVER
	else:
		button.modulate = COLOR_NORMAL
