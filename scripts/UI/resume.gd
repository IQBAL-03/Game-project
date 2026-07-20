extends TextureButton

func _on_mouse_entered():
	modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void:
	var main_menu = get_parent().get_parent()

	if main_menu is Control:
		main_menu.visible = false
	else:
		get_parent().visible = false

	get_tree().paused = false
