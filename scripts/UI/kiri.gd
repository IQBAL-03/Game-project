extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed():
	var equipment = get_node("../..")
	if equipment and equipment.has_method("prev_page"):
		equipment.prev_page()

func _on_mouse_entered():
	if not disabled:
		modulate = Color(1.3, 1.3, 1.3, 1)

func _on_mouse_exited():
	if not disabled:
		modulate = Color(1, 1, 1, 1)
