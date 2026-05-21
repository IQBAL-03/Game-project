extends Camera2D

@export var camera_zoom: Vector2 = Vector2(1.0, 1.0)
@export var left_limit: int = 0
@export var top_limit: int = 0
@export var right_limit: int = 6663
@export var bottom_limit: int = 1080


@export var debug_limits: bool = false

func _ready() -> void:
	zoom = camera_zoom
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
