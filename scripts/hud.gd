extends CanvasLayer

var player: CharacterBody2D = null
var health_component: Node = null

var hearts_container: HBoxContainer = null

var heart_icons: Array[TextureRect] = []
var heart_full_tex: Texture2D = null
var heart_half_tex: Texture2D = null
var heart_empty_tex: Texture2D = null

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	await get_tree().process_frame
	_connect_to_player()

func _build_ui() -> void:
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0)
	panel_style.draw_center = false
	panel_style.border_width_left = 0
	panel_style.border_width_right = 0
	panel_style.border_width_top = 0
	panel_style.border_width_bottom = 0

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
	heart_half_tex = load("res://player/heart_half.png")
	heart_empty_tex = load("res://player/heart_empty.png")

	for i in range(count):
		var tex_rect = TextureRect.new()
		tex_rect.texture = heart_full_tex
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.custom_minimum_size = Vector2(32, 32)
		hearts_container.add_child(tex_rect)
		heart_icons.append(tex_rect)

func _on_health_changed(current: float, maximum: float) -> void:
	var max_int = ceili(maximum)
	if heart_icons.size() != max_int:
		_setup_hearts(max_int)
		
	for i in range(heart_icons.size()):
		var heart_val = i + 1
		if current >= heart_val:
			heart_icons[i].texture = heart_full_tex
		elif current >= heart_val - 0.5:
			heart_icons[i].texture = heart_half_tex
		else:
			heart_icons[i].texture = heart_empty_tex
