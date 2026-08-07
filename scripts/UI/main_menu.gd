extends Control

func _ready() -> void:
	_apply_fullscreen()
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 100
	z_as_relative = false
	ButtonHover.apply_to_tree(self)
	if not get_viewport().size_changed.is_connected(_on_viewport_size_changed):
		get_viewport().size_changed.connect(_on_viewport_size_changed)

func _on_viewport_size_changed() -> void:
	_apply_fullscreen()

func _apply_fullscreen() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_KEEP_SIZE)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		var settings = get_tree().root.find_child("Settings", true, false)
		if settings and settings.visible:
			# Jika Settings sedang terbuka, biarkan settings_menu.gd yang menangani ESC (auto-save & tutup settings)
			return
		
		# Jika Settings tidak terbuka, toggle MainMenu (Pause Menu)
		if visible:
			_on_close_pressed()
		else:
			visible = true
			get_tree().paused = true
		get_viewport().set_input_as_handled()

func _on_close_pressed() -> void:
	visible = false
	get_tree().paused = false
