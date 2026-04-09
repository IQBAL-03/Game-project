extends CanvasLayer

func _ready() -> void:
	layer = 200
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	await get_tree().process_frame
	_connect_to_player()

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
	margin.add_theme_constant_override("margin_left", 50)
	margin.add_theme_constant_override("margin_right", 50)
	margin.add_theme_constant_override("margin_top", 35)
	margin.add_theme_constant_override("margin_bottom", 35)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 18)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(vbox)

	var title = Label.new()
	title.text = "GAME  OVER"
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 12)
	vbox.add_child(spacer)

	var btn_retry = _make_button("Coba Lagi")
	btn_retry.pressed.connect(_on_retry)
	vbox.add_child(btn_retry)

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

func _connect_to_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var health_component = player.get_node_or_null("HealthComponent")
		if health_component:
			health_component.died.connect(_on_player_died)

func _on_player_died() -> void:
	await get_tree().create_timer(1.5).timeout
	visible = true

func _on_retry() -> void:
	visible = false
	get_tree().reload_current_scene()

func _on_quit() -> void:
	get_tree().quit()
