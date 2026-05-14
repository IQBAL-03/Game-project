extends CanvasLayer

var is_paused: bool = false

func _ready() -> void:
	layer = 150
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()

func _build_ui() -> void:
	var overlay = ColorRect.new()
	overlay.color = Color(0.05, 0.10, 0.42, 0.78)
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)

	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.09, 0.18, 0.60, 0.97)
	panel_style.border_width_left = 5
	panel_style.border_width_right = 5
	panel_style.border_width_top = 5
	panel_style.border_width_bottom = 5
	panel_style.border_color = Color(0.03, 0.07, 0.28, 1.0)
	panel_style.corner_radius_top_left = 8
	panel_style.corner_radius_top_right = 8
	panel_style.corner_radius_bottom_left = 8
	panel_style.corner_radius_bottom_right = 8

	var panel = PanelContainer.new()
	panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 45)
	margin.add_theme_constant_override("margin_right", 45)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(vbox)

	var title = Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 10)
	vbox.add_child(spacer)

	var btn_resume = _make_button("Lanjutkan")
	btn_resume.pressed.connect(_on_resume)
	vbox.add_child(btn_resume)

	var btn_restart = _make_button("Restart")
	btn_restart.pressed.connect(_on_restart)
	vbox.add_child(btn_restart)

	var btn_quit = _make_button("Keluar")
	btn_quit.pressed.connect(_on_quit)
	vbox.add_child(btn_quit)

func _make_button(text: String) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(240, 54)
	btn.focus_mode = Control.FOCUS_NONE

	btn.add_theme_stylebox_override("normal", _button_style(Color(0.93, 0.94, 0.97, 1.0)))
	btn.add_theme_stylebox_override("hover", _button_style(Color(0.80, 0.85, 0.97, 1.0)))
	btn.add_theme_stylebox_override("pressed", _button_style(Color(0.68, 0.73, 0.94, 1.0)))
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color", Color(0.08, 0.16, 0.50, 1.0))
	btn.add_theme_color_override("font_hover_color", Color(0.04, 0.08, 0.30, 1.0))
	btn.add_theme_color_override("font_pressed_color", Color(0.02, 0.05, 0.20, 1.0))
	btn.add_theme_font_size_override("font_size", 22)
	return btn

func _button_style(bg: Color) -> StyleBoxFlat:
	var s = StyleBoxFlat.new()
	s.bg_color = bg
	s.border_width_left = 4
	s.border_width_right = 4
	s.border_width_top = 4
	s.border_width_bottom = 4
	s.border_color = Color(0.04, 0.08, 0.30, 1.0)
	s.corner_radius_top_left = 5
	s.corner_radius_top_right = 5
	s.corner_radius_bottom_left = 5
	s.corner_radius_bottom_right = 5
	return s

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		if is_paused:
			_on_resume()
		else:
			_toggle_pause()

func _toggle_pause() -> void:
	is_paused = true
	visible = true
	get_tree().paused = true

func _on_resume() -> void:
	is_paused = false
	visible = false
	get_tree().paused = false

func _on_restart() -> void:
	is_paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit() -> void:
	get_tree().quit()
