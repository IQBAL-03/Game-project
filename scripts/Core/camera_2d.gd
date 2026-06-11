extends Camera2D

const DESIGN_SIZE := Vector2(1920.0, 1080.0)

@export var camera_zoom: Vector2 = Vector2(1.0, 1.0)
@export var left_limit: int = 0
@export var top_limit: int = 0
@export var right_limit: int = 6663
@export var bottom_limit: int = 1080

@export_group("Smooth follow")
@export var smooth_follow: bool = true
@export_range(1.0, 30.0, 0.5) var smoothing_speed: float = 12.0
@export var physics_interpolation_on_player: bool = true

@export_group("Debug")
@export var debug_limits: bool = false

func _ready() -> void:
	_apply_limits()
	_apply_viewport_zoom()
	position_smoothing_enabled = smooth_follow
	position_smoothing_speed = smoothing_speed
	if physics_interpolation_on_player:
		var body := get_parent() as CharacterBody2D
		if body:
			body.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_ON
	if not get_viewport().size_changed.is_connected(_on_viewport_size_changed):
		get_viewport().size_changed.connect(_on_viewport_size_changed)

func _on_viewport_size_changed() -> void:
	_apply_viewport_zoom()

func _apply_viewport_zoom() -> void:
	var size := get_viewport().get_visible_rect().size
	var fit := minf(size.x / DESIGN_SIZE.x, size.y / DESIGN_SIZE.y)
	if fit < 1.0:
		zoom = camera_zoom * Vector2(fit, fit)
	else:
		zoom = camera_zoom

func _apply_limits() -> void:
	limit_left = left_limit
	limit_top = top_limit
	limit_right = right_limit
	limit_bottom = bottom_limit

func _unhandled_input(event: InputEvent) -> void:
	if not debug_limits:
		return
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode != KEY_F3:
		return
	_print_limit_debug()

func _print_limit_debug() -> void:
	var center := get_screen_center_position()
	var half_w := get_viewport_rect().size.x * 0.5 / zoom.x
	var left_edge := center.x - half_w
	var right_edge := center.x + half_w
	print("--- Camera limit debug (F3) ---")
	print("Pusat layar (world X): ", center.x)
	print("Tepi kiri layar: ", left_edge, " | tepi kanan layar: ", right_edge)
	print("limit_right (atur di Inspector): ", limit_right)
	print("Saat mentok kanan, set right_limit ≈ tepi kanan layar (nilai di atas)")
	print("Player global X: ", get_parent().global_position.x if get_parent() else "n/a")
