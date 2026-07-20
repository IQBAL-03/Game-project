extends TextureButton

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/level.tscn")

func _on_mouse_entered():
	modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func _ready():
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
