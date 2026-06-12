extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:

	get_tree().paused = false
	get_tree().reload_current_scene()
