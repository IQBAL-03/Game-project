extends Control

func _ready() -> void:
	z_index = 100
	z_as_relative = false
	ButtonHover.apply_to_tree(self)
