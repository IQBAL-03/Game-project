extends TextureButton

func _on_mouse_entered():
	modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)