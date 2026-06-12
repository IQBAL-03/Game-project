extends Control

func _ready() -> void:
	_apply_fullscreen()
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
