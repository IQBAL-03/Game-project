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
	var existing = get_tree().root.find_child("Settings", true, false)
	if existing:
		existing.visible = true
	else:
		var settings_scene = preload("res://scenes/Menu/settings.tscn").instantiate()
		get_tree().root.add_child(settings_scene)