extends Node

const DESIGN_SIZE := Vector2i(1920, 1080)

func _ready() -> void:
	_apply()
	get_tree().root.size_changed.connect(_apply)

func _apply() -> void:
	var root: Window = get_tree().root
	root.content_scale_size = DESIGN_SIZE
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
