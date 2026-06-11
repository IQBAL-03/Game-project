extends TextureButton

var key_icon: Texture2D = null

func _ready() -> void:
	texture_normal = null

func show_key_icon(_key_type: String) -> void:
	var key_texture_path = "res://map/Map/PNG/key-icon.png"
	key_icon = load(key_texture_path)
	texture_normal = key_icon
