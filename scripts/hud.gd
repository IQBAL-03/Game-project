extends CanvasLayer

var player: CharacterBody2D = null
var health_component: Node = null

var hearts_container: HBoxContainer = null

var heart_icons: Array[TextureRect] = []
var heart_full_tex: Texture2D = null
var heart_empty_tex: Texture2D = null

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	await get_tree().process_frame
	_connect_to_player()

func _build_ui() -> void:
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.08, 0.16, 0.52, 0.82)
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.border_color = Color(0.03, 0.07, 0.28, 1.0)
	panel_style.corner_radius_top_left = 6
	panel_style.corner_radius_top_right = 6
	panel_style.corner_radius_bottom_left = 6
	panel_style.corner_radius_bottom_right = 6

	var panel = PanelContainer.new()
	panel.position = Vector2(12, 12)
	panel.add_theme_stylebox_override("panel", panel_style)
	add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	margin.add_child(hbox)

	hearts_container = HBoxContainer.new()
	hearts_container.add_theme_constant_override("separation", 4)
	hbox.add_child(hearts_container)

func _connect_to_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		health_component = player.get_node_or_null("HealthComponent")
		if health_component:
			_setup_hearts(health_component.get_max_health())
			health_component.health_changed.connect(_on_health_changed)
			_on_health_changed(health_component.get_current_health(), health_component.get_max_health())

func _setup_hearts(count: int) -> void:
	for h in heart_icons:
		h.queue_free()
	heart_icons.clear()

	heart_full_tex = load("res://player/heart_full.png")
	heart_empty_tex = load("res://player/heart_empty.png")

	for i in range(count):
		var tex_rect = TextureRect.new()
		tex_rect.texture = heart_full_tex
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.custom_minimum_size = Vector2(32, 32)
		hearts_container.add_child(tex_rect)
		heart_icons.append(tex_rect)

func _on_health_changed(current: int, maximum: int) -> void:
	if heart_icons.size() != maximum:
		_setup_hearts(maximum)
	for i in range(heart_icons.size()):
		heart_icons[i].texture = heart_full_tex if i < current else heart_empty_tex
