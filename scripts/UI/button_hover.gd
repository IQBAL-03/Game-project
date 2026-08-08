extends Node

var click_player: AudioStreamPlayer = null

func _ready() -> void:
	click_player = AudioStreamPlayer.new()
	var sound = load("res://Backsound/button-click.mp3")
	if sound:
		click_player.stream = sound
	click_player.bus = "SFX"
	click_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(click_player)

func apply_to_tree(root: Node) -> void:
	for child in root.find_children("*", "BaseButton", true, false):
		if child is BaseButton:
			apply_to_button(child)

func apply_to_button(button: BaseButton) -> void:
	if not button.mouse_entered.is_connected(_on_mouse_entered):
		button.mouse_entered.connect(_on_mouse_entered.bind(button))
	if not button.mouse_exited.is_connected(_on_mouse_exited):
		button.mouse_exited.connect(_on_mouse_exited.bind(button))
	if not button.pressed.is_connected(_on_button_pressed):
		button.pressed.connect(_on_button_pressed)

func _on_mouse_entered(button: BaseButton) -> void:
	button.modulate = Color(0.7, 0.7, 0.7, 1.0)

func _on_mouse_exited(button: BaseButton) -> void:
	button.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_button_pressed() -> void:
	if click_player and click_player.stream:
		click_player.play()
